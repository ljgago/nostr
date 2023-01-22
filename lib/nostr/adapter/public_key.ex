defmodule Nostr.Adapter.PublicKey do
  @moduledoc """
  Documentation for `Nostr.Adapter.PublicKey`.
  """

  # Public key

  @callback from_secret_key(seckey :: String.t()) :: {:ok, String.t()} | {:error, String.t()}

  # Bech32 and hex transformations

  @callback encode(pubkey :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  @callback encode!(pubkey :: String.t()) :: String.t()

  @callback decode(npub :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  @callback decode!(npub :: String.t()) :: String.t()
end
