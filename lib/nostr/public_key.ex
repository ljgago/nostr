defmodule Nostr.PublicKey do
  @moduledoc """
  Documentation for `Nostr.PublicKey`.
  """

  alias Nostr.Native

  @behaviour Nostr.Adapter.PublicKey

  @doc """
  Generate a public key from the secret key.

  ## Examples:

      iex> Nostr.PublicKey.from_secret_key("3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d")
      {:ok, "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029"}

  """
  @impl true
  @spec from_secret_key(seckey :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def from_secret_key(seckey) do
    Native.nip01_generate_public_key(seckey)
  end

  @doc """
  Encode a public key to bech32 using the "npub" prefix.

  ## Examples:

      iex> Nostr.PublicKey.encode("718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029")
      {:ok, "npub1wxxh2mmqeaghnme4kwwudkel7k8sfsrnf7qld4zppu9sglwljq5shd0y24"}

  """
  @impl true
  @spec encode(pubkey :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(pubkey) do
    Native.nip19_encode(pubkey, "npub")
  end

  @doc """
  Encode a public key to bech32 using the "npub" prefix.

  If fail, raise a error.

  ## Examples:

      iex> Nostr.PublicKey.encode!("718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029")
      "npub1wxxh2mmqeaghnme4kwwudkel7k8sfsrnf7qld4zppu9sglwljq5shd0y24"

  """
  @impl true
  @spec encode!(pubkey :: String.t()) :: String.t()
  def encode!(pubkey) do
    case encode(pubkey) do
      {:ok, npub} -> npub
      {:error, error} -> raise ArgumentError, message: error
    end
  end

  @doc """
  Decode a public key from bech32 to hex format.

  ## Examples:

      iex> Nostr.PublicKey.decode("npub1wxxh2mmqeaghnme4kwwudkel7k8sfsrnf7qld4zppu9sglwljq5shd0y24")
      {:ok, "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029"}

  """
  @impl true
  @spec decode(npub :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(npub) do
    case Nostr.Native.nip19_decode(npub) do
      {:ok, %{data: pubkey, prefix: "npub"}} -> {:ok, pubkey}
      {:error, error} -> {:error, error}
      _ -> {:error, "is't a npub key"}
    end
  end

  @doc """
  Decode a public key from bech32 to hex format.

  If fail, raise a error.

  ## Examples:

      iex> Nostr.PublicKey.decode!("npub1wxxh2mmqeaghnme4kwwudkel7k8sfsrnf7qld4zppu9sglwljq5shd0y24")
      "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029"

  """
  @impl true
  @spec decode!(npub :: String.t()) :: String.t()
  def decode!(npub) do
    case decode(npub) do
      {:ok, pubkey} -> pubkey
      {:error, error} -> raise ArgumentError, message: error
    end
  end
end
