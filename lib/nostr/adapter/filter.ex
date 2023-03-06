defmodule Nostr.Adapter.Filter do
  @moduledoc """
  Documentation for `Nostr.Adapter.Filter`.
  """

  @type t :: struct()

  # Event

  @callback new() :: t
  @callback new(fields :: keyword()) :: t
  @callback replace(t, keyword()) :: t

  @callback to_json(t) :: String.t()
  @callback from_json(filter :: String.t()) :: t
end
