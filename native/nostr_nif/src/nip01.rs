use rustler::{NifMap, NifStruct};
use secp256k1::hashes::sha256;
use secp256k1::{rand, schnorr, KeyPair, Message, Secp256k1, XOnlyPublicKey};
use serde_json::json;
use std::str::FromStr;

mod atoms {
    rustler::atoms! {
        ok,
        error,
    }
}

#[derive(NifMap)]
pub struct NifKeyPair {
    pubkey: String,
    seckey: String,
}

#[derive(NifStruct)]
#[module = "Nostr.Event"]
pub struct NifEvent {
    id: String,
    pubkey: String,
    created_at: i64,
    kind: i64,
    tags: Vec<Vec<String>>,
    content: String,
    sig: String,
}

fn event_serialize(event: &NifEvent) -> Result<String, String> {
    let event_array = json!([
        0,
        event.pubkey,
        event.created_at,
        event.kind,
        event.tags,
        event.content,
    ]);

    if let Ok(json_array) = serde_json::to_string(&event_array) {
        Ok(json_array)
    } else {
        Err(format!("failed to serialize event"))
    }
}

fn sign_message(message: &str, secret_key: &str) -> Result<String, String> {
    let secp = Secp256k1::new();
    let message_hashed = Message::from_hashed_data::<sha256::Hash>(message.as_bytes());

    match KeyPair::from_seckey_str(&secp, secret_key) {
        Ok(key_pair) => {
            let sig = secp.sign_schnorr(&message_hashed, &key_pair);
            Ok(sig.to_string())
        }
        Err(_) => Err(format!("malformed secret key")),
    }
}

fn verify_message(message: &str, public_key: &str, signature: &str) -> Result<bool, String> {
    let message_hashed = Message::from_hashed_data::<sha256::Hash>(message.as_bytes());

    if let Ok(sig) = schnorr::Signature::from_str(signature) {
        if let Ok(x_only_public_key) = XOnlyPublicKey::from_str(public_key) {
            let verify_only = Secp256k1::verification_only();
            if let Ok(()) = verify_only.verify_schnorr(&sig, &message_hashed, &x_only_public_key) {
                Ok(true)
            } else {
                Ok(false)
            }
        } else {
            Err(format!("malformed public key"))
        }
    } else {
        Err(format!("malformed signature"))
    }
}

// Main functions

#[rustler::nif(schedule = "DirtyCpu")]
pub fn nip01_new_key_pair() -> NifKeyPair {
    let secp = Secp256k1::new();
    let key_pair = KeyPair::new(&secp, &mut rand::thread_rng());
    let secret_key = key_pair.secret_key();
    let (public_key, _parity) = key_pair.x_only_public_key();

    NifKeyPair {
        pubkey: public_key.to_string(),
        seckey: secret_key.display_secret().to_string(),
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
pub fn nip01_generate_public_key(secret_key: &str) -> Result<String, String> {
    let secp = Secp256k1::new();

    match KeyPair::from_seckey_str(&secp, secret_key) {
        Ok(key_pair) => {
            let (public_key, _parity) = key_pair.x_only_public_key();
            Ok(public_key.to_string())
        }
        Err(_) => Err(format!("malformed secret key")),
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
pub fn nip01_generate_event_id(event: NifEvent) -> Result<String, String> {
    match event_serialize(&event) {
        Ok(event_serialized) => {
            let id = Message::from_hashed_data::<sha256::Hash>(event_serialized.as_bytes());
            Ok(id.to_string())
        }
        Err(e) => Err(e),
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
pub fn nip01_sign_message(message: &str, secret_key: &str) -> Result<String, String> {
    sign_message(message, secret_key)
}

#[rustler::nif(schedule = "DirtyCpu")]
pub fn nip01_verify_message(
    message: &str,
    public_key: &str,
    signature: &str,
) -> Result<bool, String> {
    verify_message(message, public_key, signature)
}

#[rustler::nif(schedule = "DirtyCpu")]
pub fn nip01_serialize_event(event: NifEvent) -> Result<String, String> {
    event_serialize(&event)
}

#[rustler::nif(schedule = "DirtyCpu")]
pub fn nip01_sign_event(event: NifEvent, secret_key: &str) -> Result<NifEvent, String> {
    match event_serialize(&event) {
        Ok(event_serialized) => match sign_message(&event_serialized, secret_key) {
            Ok(sig) => {
                let id = Message::from_hashed_data::<sha256::Hash>(&event_serialized.as_bytes())
                    .to_string();

                Ok(NifEvent {
                    id,
                    pubkey: event.pubkey,
                    created_at: event.created_at,
                    kind: event.kind,
                    tags: event.tags,
                    content: event.content,
                    sig,
                })
            }
            Err(e) => Err(e),
        },
        Err(e) => Err(e),
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
pub fn nip01_verify_event(event: NifEvent) -> Result<bool, String> {
    match event_serialize(&event) {
        Ok(event_serialized) => verify_message(&event_serialized, &event.pubkey, &event.sig),
        Err(e) => Err(e),
    }
}
