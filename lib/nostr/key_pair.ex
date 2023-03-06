defmodule Nostr.KeyPair do
  @moduledoc """
  Documentation for `Nostr.KeyPair`.
  """

  alias Nostr.Native

  @behaviour Nostr.Adapter.KeyPair

  @doc """
  Generate a random secp256k1 key pair.

  ## Examples

      iex> Nostr.KeyPair.new()
      %{
        pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
        seckey: "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d"
      }

  """
  @impl true
  @spec new() :: map()
  def new do
    Native.nip01_new_key_pair()
  end

  @doc """
  Generate a secp256k1 key pair from a secret key.

  ## Examples

      iex> Nostr.KeyPair.from_secret_key("3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d")
      {:ok,
       %{
         pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
         seckey: "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d"
       }}

  """
  @impl true
  @spec from_secret_key(String.t()) :: {:ok, map()} | {:error, String.t()}
  def from_secret_key(seckey) do
    case Native.nip01_generate_public_key(seckey) do
      {:ok, pubkey} ->
        {:ok,
         %{
           pubkey: pubkey,
           seckey: seckey
         }}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Encode the key pair from hex to bech32.

  ## Exmaples:

      iex> key_pair = %{
      ...>   pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
      ...>   seckey: "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d"
      ...> }
      iex> Nostr.KeyPair.encode(key_pair)
      {:ok,
       %{
         npub: "npub1wxxh2mmqeaghnme4kwwudkel7k8sfsrnf7qld4zppu9sglwljq5shd0y24",
         nsec: "nsec180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsgyumg0"
       }}

  """
  @impl true
  @spec encode(map()) :: {:ok, map()} | {:error, String.t()}
  def encode(%{pubkey: pubkey, seckey: seckey}) do
    with {:ok, npub} <- Native.nip19_encode(pubkey, "npub"),
         {:ok, nsec} <- Native.nip19_encode(seckey, "nsec") do
      {:ok,
       %{
         npub: npub,
         nsec: nsec
       }}
    else
      {:error, error} ->
        {:error, error}

      error ->
        {:error, error}
    end
  end

  @doc """
  Encode the key pair from hex to bech32.

  ## Exmaples:

      iex> key_pair = %{
      ...>   pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
      ...>   seckey: "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d"
      ...> }
      iex> Nostr.KeyPair.encode!(key_pair)
      %{
        npub: "npub1wxxh2mmqeaghnme4kwwudkel7k8sfsrnf7qld4zppu9sglwljq5shd0y24",
        nsec: "nsec180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsgyumg0"
      }

  """
  @impl true
  @spec encode!(map()) :: map()
  def encode!(key_pair) do
    case encode(key_pair) do
      {:ok, output} -> output
      {:error, error} -> raise ArgumentError, message: error
    end
  end

  @doc """
  Decode the key pair from bech32 to hex.

  ## Examples:

      iex> key_pair = %{
      ...>   npub: "npub1wxxh2mmqeaghnme4kwwudkel7k8sfsrnf7qld4zppu9sglwljq5shd0y24",
      ...>   nsec: "nsec180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsgyumg0"
      ...> }
      iex> Nostr.KeyPair.decode(key_pair)
      {:ok,
       %{
         pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
         seckey: "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d"
       }}

  """
  @impl true
  @spec decode(map()) :: {:ok, map()} | {:error, String.t()}
  def decode(%{npub: npub, nsec: nsec}) do
    with {:ok, %{data: pubkey}} <- Native.nip19_decode(npub),
         {:ok, %{data: seckey}} <- Native.nip19_decode(nsec) do
      {:ok,
       %{
         pubkey: pubkey,
         seckey: seckey
       }}
    else
      {:error, error} ->
        raise error

      error ->
        {:error, error}
    end
  end

  @doc """
  Decode the key pair from bech32 to hex.

  ## Examples:

      iex> key_pair = %{
      ...>   npub: "npub1wxxh2mmqeaghnme4kwwudkel7k8sfsrnf7qld4zppu9sglwljq5shd0y24",
      ...>   nsec: "nsec180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsgyumg0"
      ...> }
      iex> Nostr.KeyPair.decode!(key_pair)
      %{
        pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
        seckey: "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d"
      }

  """
  @impl true
  @spec decode!(map()) :: map()
  def decode!(key_pair) do
    case decode(key_pair) do
      {:ok, output} -> output
      {:error, error} -> raise ArgumentError, message: error
    end
  end
end
