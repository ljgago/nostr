defmodule Nostr.Adapter.Metadata do
  @moduledoc """
  Documentation for `Nostr.Adapter.KeyPair`.
  """

  # NIP-19

  @callback encode_note(event_id :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  @callback decode_note(note :: String.t()) :: {:ok, String.t()} | {:error, String.t()}

  # Bech32 prefix with TLV (Type-Length-Value)

  @callback encode_event(event_id :: String.t(), relays :: [String.t()]) ::
              {:ok, String.t()} | {:error, String.t()}
  @callback decode_event(nevent :: String.t()) :: {:ok, map()} | {:error, String.t()}

  @callback encode_profile(pubkey :: String.t(), relays :: [String.t()]) ::
              {:ok, String.t()} | {:error, String.t()}
  @callback decode_profile(nprofile :: String.t()) :: {:ok, map()} | {:error, String.t()}
end
