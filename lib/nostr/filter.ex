defmodule Nostr.Filter do
  @moduledoc """
  Documentation for `Nostr.Filter`.
  """

  alias __MODULE__, as: Filter

  defstruct ids: [],
            authors: [],
            kinds: [],
            "#e": [],
            "#p": [],
            since: 0,
            until: 0,
            limit: 0

  @type t :: %__MODULE__{
          ids: [String.t()],
          authors: [String.t()],
          kinds: [non_neg_integer()],
          "#e": [String.t()],
          "#p": [String.t()],
          since: non_neg_integer(),
          until: non_neg_integer(),
          limit: non_neg_integer()
        }

  @behaviour Nostr.Adapter.Filter

  defimpl Jason.Encoder, for: Filter do
    def encode(value, opts) do
      Jason.Encode.map(
        Map.take(value, [:ids, :authors, :kinds, :"#e", :"#p", :since, :until, :limit]),
        opts
      )
    end
  end

  @doc """

  """
  @impl true
  @spec new() :: Filter.t()
  def new do
    %Filter{}
  end

  @doc """

  """
  @impl true
  @spec new(keyword()) :: Filter.t()
  def new(fields) do
    struct(Filter, fields)
  end

  @doc """

  """
  @impl true
  @spec replace(Filter.t(), keyword()) :: Filter.t()
  def replace(filter, fields) do
    struct(filter, fields)
  end

  @doc """
  Encode the event struct to json string.

  """
  @impl true
  @spec to_json(Filter.t()) :: String.t()
  def to_json(filter) do
    filter
    |> Jason.encode!()
  end

  @doc """

  """
  @impl true
  @spec from_json(String.t()) :: Filter.t()
  def from_json(filter_json) do
    filter = Jason.decode!(filter_json)

    %Filter{
      ids: filter["ids"] || [],
      authors: filter["authors"] || [],
      kinds: filter["kinds"] || [],
      "#e": filter["#e"] || [],
      "#p": filter["#p"] || [],
      since: filter["since"] || 0,
      until: filter["until"] || 0,
      limit: filter["until"] || 0
    }
  end
end
