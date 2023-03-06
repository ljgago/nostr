defmodule Nostr.SecretKey do
  @moduledoc """
  Documentation for `Nostr.Seckey`.
  """

  alias Nostr.Native

  @behaviour Nostr.Adapter.SecretKey

  @doc """
  Get the public key from its secret key.

  ## Examples

      iex> Nostr.Key.get_public_key("3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d")
      {:ok, "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029"}

  """
  @impl true
  @spec get_public_key(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def get_public_key(seckey) do
    Native.nip01_generate_public_key(seckey)
  end

  @doc """
  Encode a secret key to bech32 using the "nsec" prefix.

  ## Examples:

      iex> Nostr.SecretKey.encode("3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d")
      {:ok, "nsec180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsgyumg0"}

  """
  @impl true
  @spec encode(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(seckey) do
    Native.nip19_encode(seckey, "nsec")
  end

  @doc """
  Encode a secret key to bech32 using the "nsec" prefix.

  If fail, raise a error.

  ## Examples:

      iex> Nostr.SecretKey.encode!("3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d")
      "nsec180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsgyumg0"

  """
  @impl true
  @spec encode!(String.t()) :: String.t()
  def encode!(seckey) do
    case encode(seckey) do
      {:ok, nsec} -> nsec
      {:error, error} -> raise ArgumentError, message: error
    end
  end

  @doc """
  Decode a secret key from bech32 to hex format.

  ## Examples:

      iex> Nostr.SecretKey.decode("nsec180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsgyumg0")
      {:ok, "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d"}

  """
  @impl true
  @spec decode(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(nsec) do
    case Nostr.Native.nip19_decode(nsec) do
      {:ok, %{data: seckey, prefix: "nsec"}} -> {:ok, seckey}
      {:error, error} -> {:error, error}
      _ -> {:error, "is't a nsec key"}
    end
  end

  @doc """
  Decode a secret key from bech32 to hex format.

  If fail, raise a error.

  ## Examples:

      iex> Nostr.SecretKey.decode!("nsec180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsgyumg0")
      "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d"

  """
  @impl true
  @spec decode!(String.t()) :: String.t()
  def decode!(nsec) do
    case decode(nsec) do
      {:ok, seckey} -> seckey
      {:error, error} -> raise ArgumentError, message: error
    end
  end
end
