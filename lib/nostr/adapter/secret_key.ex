defmodule Nostr.Adapter.SecretKey do
  @moduledoc """
  Documentation for `Nostr.Adapter.SecretKey`.
  """

  # Secret key

  @callback get_public_key(seckey :: String.t()) :: {:ok, String.t()} | {:error, String.t()}

  # Bech32 and hex transformations

  @callback encode(seckey :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  @callback encode!(seckey :: String.t()) :: String.t()

  @callback decode(nsec :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  @callback decode!(nsec :: String.t()) :: String.t()
end
