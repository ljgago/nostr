defmodule Nostr.Adapter.KeyPair do
  @moduledoc """
  Documentation for `Nostr.Adapter.KeyPair`.
  """

  # Key pair

  @callback new() :: map()
  @callback from_secret_key(seckey :: String.t()) :: {:ok, map()} | {:error, String.t()}

  # Bech32 and hex transformations

  @callback encode(key_pair :: map()) :: {:ok, map()} | {:error, String.t()}
  @callback encode!(key_pair :: map()) :: map()

  @callback decode(key_pair :: map()) :: {:ok, map()} | {:error, String.t()}
  @callback decode!(key_pair :: map()) :: map()
end
