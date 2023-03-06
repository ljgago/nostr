defmodule Nostr.Message do
  @moduledoc """
  Documentation for `Nostr.Message`.
  """

  alias Nostr.Native

  @behaviour Nostr.Adapter.Message

  @doc """

  """
  @impl true
  @spec sign(String.t(), String.t()) :: {:ok, String.t()}
  def sign(message, secret_key) do
    Nostr.Native.nip01_sign_message(message, secret_key)
  end

  @doc """

  """
  @impl true
  @spec verify(String.t(), String.t(), String.t()) :: {:ok, boolean()} | {:error, String.t()}
  def verify(message, public_key, signature) do
    Native.nip01_verify_message(message, public_key, signature)
  end
end
