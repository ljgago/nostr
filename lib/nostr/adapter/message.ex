defmodule Nostr.Adapter.Message do
  @moduledoc """
  Documentation for `Nostr.Adapter.Message`.
  """

  # Schnorr signature

  @callback sign(message :: String.t(), seckey :: String.t()) :: {:ok, String.t()}
  @callback verify(
              message :: String.t(),
              pubkey :: String.t(),
              signature :: String.t()
            ) :: {:ok, boolean()} | {:error, String.t()}

  # Encrypt and decrypt messages

  @callback encrypt(message :: String.t(), pubkey :: String.t(), seckey :: String.t()) ::
              {:ok, String.t()} | {:error, String.t()}
  @callback decrypt(message :: String.t(), pubkey :: String.t(), seckey :: String.t()) ::
              {:ok, String.t()} | {:error, String.t()}
end
