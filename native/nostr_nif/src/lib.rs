pub mod error;

mod nip01;
mod nip19;

use nip01::*;
use nip19::*;

rustler::init!(
    "Elixir.Nostr.Native",
    [
        // nip01
        nip01_new_key_pair,
        nip01_generate_public_key,
        nip01_generate_event_id,
        nip01_sign_message,
        nip01_verify_message,
        nip01_sign_event,
        nip01_verify_event,
        // nip19
        nip19_encode,
        nip19_decode,
        nip19_encode_tlv,
        nip19_decode_tlv,
    ]
);
