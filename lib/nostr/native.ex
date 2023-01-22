defmodule Nostr.Native do
  use Rustler,
    otp_app: :nostr,
    crate: :nostr_nif

  # NIP-01
  def nip01_new_key_pair(), do: err()
  def nip01_generate_public_key(_seckey), do: err()
  def nip01_generate_event_id(_event), do: err()
  def nip01_sign_message(_message, _seckey), do: err()
  def nip01_verify_message(_message, _pubkey, _signature), do: err()
  def nip01_sign_event(_event, _seckey), do: err()
  def nip01_verify_event(_event), do: err()

  # NIP-19
  def nip19_encode(_data, _hrp), do: err()
  def nip19_decode(_data), do: err()
  def nip19_encode_tlv(_data, _relays, _hrp), do: err()
  def nip19_decode_tlv(_data), do: err()

  defp err, do: :erlang.nif_error(:nif_not_loaded)
end
