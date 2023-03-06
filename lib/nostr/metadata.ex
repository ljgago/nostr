defmodule Nostr.Metadata do
  @moduledoc """
  Documentation for `Nostr.Metadata`.
  """

  alias Nostr.Native

  @behaviour Nostr.Adapter.Metadata

  @doc """
  Encodes a event id from hex to bech32.

  ## Example:

      iex> Nostr.Event.encode_note("2798df6067fb67f1e59a66f9fc97c69d052777ee0f8421fe643ecf5001573c7d")
      {:ok, "note1y7vd7cr8ldnlrev6vmule97xn5zjwalwp7zzrlny8m84qq2h837sv07fzd"}

  """
  @impl true
  @spec encode_note(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode_note(event_id) do
    Native.nip19_encode(event_id, "note")
  end

  @doc """
  Decodes a event id from bech32 to hex.

  ## Example:

      iex> Nostr.Event.encode_note("note1y7vd7cr8ldnlrev6vmule97xn5zjwalwp7zzrlny8m84qq2h837sv07fzd")
      {:ok, "2798df6067fb67f1e59a66f9fc97c69d052777ee0f8421fe643ecf5001573c7d"}

  """
  @impl true
  @spec decode_note(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode_note(note) do
    case Native.nip19_decode(note) do
      {:ok, %{data: event_id, prefix: "note"}} -> {:ok, event_id}
      {:error, error} -> {:error, error}
      _ -> {:error, "is't a note id encoded to bech32"}
    end
  end

  @doc """

  """
  @impl true
  @spec encode_event(String.t(), [String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def encode_event(event_id, relays) do
    Native.nip19_encode_tlv(event_id, relays, "nevent")
  end

  @doc """

  """
  @impl true
  @spec decode_event(String.t()) :: {:ok, map()} | {:error, String.t()}
  def decode_event(nevent) do
    Native.nip19_decode_tlv(nevent)
  end

  @doc """

  """
  @impl true
  @spec encode_profile(String.t(), [String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def encode_profile(public_key, relays) do
    Native.nip19_encode_tlv(public_key, relays, "nprofile")
  end

  @doc """

  """
  @impl true
  @spec decode_profile(String.t()) :: {:ok, map()} | {:error, String.t()}
  def decode_profile(nprofile) do
    case Native.nip19_decode_tlv(nprofile) do
      {:ok, profile} ->
        {:ok, %{prefix: profile.prefix, public_key: profile.data, relays: profile.relays}}

      {:error, error} ->
        {:error, error}
    end
  end
end
