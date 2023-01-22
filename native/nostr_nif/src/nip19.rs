use bech32::{self, FromBase32, ToBase32, Variant};
use rustler::NifMap;

mod atoms {
    rustler::atoms! {
        ok,
        error,
    }
}

enum TLV {
    Default,
    Relay,
}

#[derive(NifMap)]
pub struct NifDecode {
    prefix: String,
    data: String,
}

#[derive(NifMap, Clone)]
pub struct NifDecodeTLV {
    prefix: String,
    data: String,
    relays: Vec<String>,
}

fn u8_to_hex(data: &[u8]) -> Result<String, String> {
    let output = data
        .iter()
        .fold(format!(""), |acc, val| format!("{}{:02x}", acc, val));

    Ok(output)
}

fn hex_to_u8(data: &str) -> Result<Vec<u8>, String> {
    if (data.len() % 2) != 0 {
        return Err(format!("hex string must be even"));
    }

    let output: Result<Vec<_>, _> = (0..data.len())
        .step_by(2)
        .map(|i| u8::from_str_radix(&data[i..i + 2], 16))
        .collect();

    if let Ok(result) = output {
        Ok(result)
    } else {
        Err(format!("bad hex characters"))
    }
}

fn u8_to_bech32(data: &[u8], hrp: &str) -> Result<String, String> {
    let encoded_u5 = data.to_vec().to_base32();

    if let Ok(encoded) = bech32::encode(hrp, encoded_u5, Variant::Bech32) {
        Ok(encoded)
    } else {
        Err(format!("failed to encode to bech32"))
    }
}

fn bech32_to_u8(data: &str) -> Result<(String, Vec<u8>), String> {
    if let Ok((prefix, decoded_u5, _)) = bech32::decode(data) {
        if let Ok(decoded_u8) = Vec::<u8>::from_base32(&decoded_u5) {
            Ok((prefix, decoded_u8))
        } else {
            Err(format!("failed to decode to binary"))
        }
    } else {
        Err(format!("failed to decode from bech32"))
    }
}

fn hex_to_bech32(data: &str, hrp: &str) -> Result<String, String> {
    if let Ok(encoded_u8) = hex_to_u8(data) {
        let encoded_u5 = encoded_u8.to_base32();

        if let Ok(encoded) = bech32::encode(hrp, encoded_u5, Variant::Bech32) {
            Ok(encoded)
        } else {
            Err(format!("failed to encode to bech32"))
        }
    } else {
        Err(format!("malformed hex string"))
    }
}

fn bech32_to_hex(data: &str) -> Result<NifDecode, String> {
    match bech32_to_u8(data) {
        Ok((prefix, data_u8)) => {
            if let Ok(data) = u8_to_hex(&data_u8) {
                Ok(NifDecode { data, prefix })
            } else {
                Err(format!("failed to decode u8 to hex"))
            }
        }
        Err(e) => Err(e),
    }
}

fn write_tlv(buf: &mut Vec<u8>, typ: TLV, value: &[u8]) {
    let len = value.len() as u8;
    buf.push(typ as u8);
    buf.push(len);
    buf.append(&mut value.to_vec().clone());
}

fn read_tlv(data: &[u8]) -> Result<(TLV, Vec<u8>), String> {
    if data.len() < 2 {
        return Ok((TLV::Default, vec![]));
    }

    let typ = match data[0] {
        0 => TLV::Default,
        1 => TLV::Relay,
        typ => return Err(format!("wrong type code {}", typ)),
    };

    let len = data[1] as usize;
    let value = data[2..(2 + len)].to_vec();

    Ok((typ, value))
}

#[rustler::nif(schedule = "DirtyCpu")]
pub fn nip19_encode(data: &str, hrp: &str) -> Result<String, String> {
    hex_to_bech32(data, hrp)
}

#[rustler::nif(schedule = "DirtyCpu")]
pub fn nip19_decode(data: &str) -> Result<NifDecode, String> {
    bech32_to_hex(data)
}

#[rustler::nif(schedule = "DirtyCpu")]
pub fn nip19_encode_tlv(data: &str, relays: Vec<String>, hrp: &str) -> Result<String, String> {
    let mut buf: Vec<u8> = Vec::new();

    if let Ok(data_u8) = hex_to_u8(data) {
        write_tlv(&mut buf, TLV::Default, &data_u8);

        for relay in relays {
            write_tlv(&mut buf, TLV::Relay, relay.as_bytes());
        }
        u8_to_bech32(&buf, hrp)
    } else {
        Err(format!("failed to encode to bech32"))
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
pub fn nip19_decode_tlv(data: &str) -> Result<NifDecodeTLV, String> {
    match bech32_to_u8(data) {
        Ok((prefix, data_u8)) => {
            let mut index: usize = 0;
            let mut data: String = String::from("");
            let mut relays: Vec<String> = Vec::new();

            loop {
                match read_tlv(&data_u8[index..]) {
                    Ok((typ, value)) => {
                        if value.len() == 0 {
                            return Ok(NifDecodeTLV {
                                prefix,
                                data,
                                relays,
                            });
                        }

                        match typ {
                            TLV::Default => {
                                if let Ok(val) = u8_to_hex(&value) {
                                    data = val;
                                } else {
                                    return Err(format!("failed to decode to hex"));
                                }
                            }
                            TLV::Relay => {
                                if let Ok(val) = String::from_utf8(value.clone()) {
                                    relays.push(val);
                                } else {
                                    return Err(format!("failed to decode relay"));
                                }
                            }
                        }

                        index += 2 + value.len();
                    }
                    Err(e) => return Err(e),
                }
            }
        }
        Err(e) => Err(e),
    }
}
