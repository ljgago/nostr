defmodule Nostr.Adapter.Event do
  @moduledoc """
  Documentation for `Nostr.Adapter.Event`.
  """

  @type t :: struct()

  # Event

  @callback new() :: t
  @callback new(fields :: Enumerable.t()) :: t
  @callback replace(t, Enumerable.t()) :: t
  @callback serialize(t) :: String.t()
  @callback generate_id(t) :: {:ok, String.t()} | {:error, String.t()}
  @callback generate_id!(t) :: String.t()

  @callback to_json(t) :: String.t()
  @callback from_json(event :: String.t()) :: t

  # Schnorr signature

  @callback sign(t, seckey :: String.t()) :: {:ok, t} | {:error, String.t()}
  @callback sign!(t, seckey :: String.t()) :: t
  @callback verify(t) :: {:ok, boolean()} | {:error, String.t()}
  @callback verify!(t) :: boolean()
end
