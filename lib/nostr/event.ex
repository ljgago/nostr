defmodule Nostr.Event do
  @moduledoc """
  Documentation for `Nostr.Event`.
  """

  alias Nostr.Native
  alias __MODULE__, as: Event

  defstruct id: "",
            pubkey: "",
            created_at: 0,
            kind: 0,
            tags: [],
            content: "",
            sig: ""

  @type t :: %__MODULE__{
          id: String.t(),
          pubkey: String.t(),
          created_at: non_neg_integer(),
          kind: non_neg_integer(),
          tags: [String.t()],
          content: String.t(),
          sig: String.t()
        }

  @behaviour Nostr.Adapter.Event

  defimpl Jason.Encoder, for: Event do
    def encode(value, opts) do
      Jason.Encode.map(
        Map.take(value, [:id, :pubkey, :created_at, :kind, :tags, :content, :sig]),
        opts
      )
    end
  end

  @doc """
  Create a new empty event.

  ## Example:

      iex> Nostr.Event.new()
      %Nostr.Event{
        id: "",
        pubkey: "",
        created_at: 0,
        kind: 0,
        tags: [],
        content: "",
        sig: ""
      }

  """
  @impl true
  @spec new() :: Event.t()
  def new do
    %Event{}
  end

  @doc """
  Create a new event from map.

  ## Example:

      iex> Nostr.Event.new(%{pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029"})
      %Nostr.Event{
        id: "",
        pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
        created_at: 0,
        kind: 0,
        tags: [],
        content: "",
        sig: ""
      }

  """
  @impl true
  @spec new(fields :: Enumerable.t()) :: Event.t()
  def new(fields) do
    struct(Event, fields)
  end

  @doc """
  doc
  """
  @impl true
  @spec replace(event :: Event.t(), fields :: Enumerable.t()) :: Event.t()
  def replace(event, fields \\ []) do
    struct(event, fields)
  end

  @doc """
  Signs a event and return a updated event with the computed event id and the signed event.

  The generated signature is different in each call.

  ## Examples

      iex> event = %Nostr.Event{
      ...>   pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
      ...>   created_at: 1671028682,
      ...>   kind: 4,
      ...>   tags: [
      ...>     ["p", "f8340b2bde651576b75af61aa26c80e13c65029f00f7f64004eece679bf7059f"]
      ...>   ],
      ...>   content: "Hello world!"
      ...> }
      iex> Nostr.Event.sign(event, "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d")
      {:ok,
       %Nostr.Event{
         id: "2798df6067fb67f1e59a66f9fc97c69d052777ee0f8421fe643ecf5001573c7d",
         pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
         created_at: 1671028682,
         kind: 4,
         tags: [
           ["p", "f8340b2bde651576b75af61aa26c80e13c65029f00f7f64004eece679bf7059f"]
         ],
         content: "Hello world!",
         sig: "9f01b0a6e178f80749a0a9599bb5fdd5a6b976421bcc26fe9fd9b8f3f106d90fceb5f250ab2a7ed42f925077acf1876803810bfcb26e9fca60d08da1b2286d63"
       }}

  """
  @impl true
  @spec sign(event :: Event.t(), seckey :: String.t()) :: {:ok, Event.t()} | {:error, String.t()}
  def sign(event, seckey) do
    Native.nip01_sign_event(event, seckey)
  end

  @doc """
  Signs a event and return a updated event with the computed event id and the signed event.

  The generated signature is different in each call.

  ## Examples

      iex> event = %Nostr.Event{
      ...>    pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
      ...>    created_at: 1671028682,
      ...>    kind: 4,
      ...>    tags: [
      ...>      ["p", "f8340b2bde651576b75af61aa26c80e13c65029f00f7f64004eece679bf7059f"]
      ...>    ],
      ...>    content: "Hello world!"
      ...> }
      iex> Nostr.Event.sign!(event, "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d")
      %Nostr.Event{
        id: "2798df6067fb67f1e59a66f9fc97c69d052777ee0f8421fe643ecf5001573c7d",
        pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
        created_at: 1671028682,
        kind: 4,
        tags: [
          ["p", "f8340b2bde651576b75af61aa26c80e13c65029f00f7f64004eece679bf7059f"]
        ],
        content: "Hello world!",
        sig: "9f01b0a6e178f80749a0a9599bb5fdd5a6b976421bcc26fe9fd9b8f3f106d90fceb5f250ab2a7ed42f925077acf1876803810bfcb26e9fca60d08da1b2286d63"
      }

  """
  @impl true
  @spec sign!(event :: Event.t(), seckey :: String.t()) :: Event.t()
  def sign!(event, seckey) do
    case sign(event, seckey) do
      {:ok, signed_event} -> signed_event
      {:error, error} -> raise error
    end
  end

  @doc """
  Verify if the event is signed correctly.

  ## Examples:

      iex> event = %Nostr.Event{
      ...>   id: "2798df6067fb67f1e59a66f9fc97c69d052777ee0f8421fe643ecf5001573c7d",
      ...>   pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
      ...>   created_at: 1671028682,
      ...>   kind: 4,
      ...>   tags: [
      ...>     ["p", "f8340b2bde651576b75af61aa26c80e13c65029f00f7f64004eece679bf7059f"]
      ...>   ],
      ...>   content: "Hello world!",
      ...>   sig: "9f01b0a6e178f80749a0a9599bb5fdd5a6b976421bcc26fe9fd9b8f3f106d90fceb5f250ab2a7ed42f925077acf1876803810bfcb26e9fca60d08da1b2286d63"
      ...> }
      iex> Nostr.Event.verify(event)
      {:ok, true}

  """
  @impl true
  @spec verify(event :: Event.t()) :: {:ok, boolean()} | {:error, String.t()}
  def verify(event) do
    Native.nip01_verify_event(event)
  end

  @doc """
  Verify if the event is signed correctly.

  ## Examples:

      iex> event = %Nostr.Event{
      ...>   id: "2798df6067fb67f1e59a66f9fc97c69d052777ee0f8421fe643ecf5001573c7d",
      ...>   pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
      ...>   created_at: 1671028682,
      ...>   kind: 4,
      ...>   tags: [
      ...>     ["p", "f8340b2bde651576b75af61aa26c80e13c65029f00f7f64004eece679bf7059f"]
      ...>   ],
      ...>   content: "Hello world!",
      ...>   sig: "9f01b0a6e178f80749a0a9599bb5fdd5a6b976421bcc26fe9fd9b8f3f106d90fceb5f250ab2a7ed42f925077acf1876803810bfcb26e9fca60d08da1b2286d63"
      ...> }
      iex> Nostr.Event.verify!(event)
      true

  """
  @impl true
  @spec verify!(event :: Event.t()) :: boolean()
  def verify!(event) do
    case verify(event) do
      {:ok, is_ok} -> is_ok
      {:error, error} -> raise error
    end
  end

  @doc """
  Serialize the event a json array

  ## Examples:

      iex> event = %Nostr.Event{
      ...>   id: "2798df6067fb67f1e59a66f9fc97c69d052777ee0f8421fe643ecf5001573c7d",
      ...>   pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
      ...>   created_at: 1671028682,
      ...>   kind: 4,
      ...>   tags: [
      ...>     ["p", "f8340b2bde651576b75af61aa26c80e13c65029f00f7f64004eece679bf7059f"]
      ...>   ],
      ...>   content: "Hello world!",
      ...>   sig: "9f01b0a6e178f80749a0a9599bb5fdd5a6b976421bcc26fe9fd9b8f3f106d90fceb5f250ab2a7ed42f925077acf1876803810bfcb26e9fca60d08da1b2286d63"
      ...> }
      iex> Nostr.Event.serialize(event)
      "[0,\\"718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029\\",1671028682,4,[[\\"p\\",\\"f8340b2bde651576b75af61aa26c80e13c65029f00f7f64004eece679bf7059f\\"]],\\"Hello world!\\"]"

  """
  @impl true
  @spec serialize(event :: Event.t()) :: String.t()
  def serialize(%Event{
        pubkey: pubkey,
        created_at: created_at,
        kind: kind,
        tags: tags,
        content: content
      }) do
    [0, pubkey, created_at, kind, tags, content]
    |> Jason.encode!()
  end

  @doc """
  Generate the event id from a event.

  ## Example:

      iex> event = %Nostr.Event{
      ...>    pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
      ...>    created_at: 1671028682,
      ...>    kind: 4,
      ...>    tags: [
      ...>      ["p", "f8340b2bde651576b75af61aa26c80e13c65029f00f7f64004eece679bf7059f"]
      ...>    ],
      ...>    content: "Hello world!"
      ...> }
      iex> Nostr.Event.generate_id(event)
      {:ok, "2798df6067fb67f1e59a66f9fc97c69d052777ee0f8421fe643ecf5001573c7d"}

  """
  @impl true
  @spec generate_id(event :: Event.t()) :: {:ok, String.t()} | {:error, String.t()}
  def generate_id(event) do
    Native.nip01_generate_event_id(event)
  end

  @doc """
  Generate the event id from a event.

  ## Example:

      iex> event = %Nostr.Event{
      ...>    pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
      ...>    created_at: 1671028682,
      ...>    kind: 4,
      ...>    tags: [
      ...>      ["p", "f8340b2bde651576b75af61aa26c80e13c65029f00f7f64004eece679bf7059f"]
      ...>    ],
      ...>    content: "Hello world!"
      ...> }
      iex> Nostr.Event.generate_id!(event)
      "2798df6067fb67f1e59a66f9fc97c69d052777ee0f8421fe643ecf5001573c7d"

  """
  @impl true
  @spec generate_id!(event :: Event.t()) :: String.t()
  def generate_id!(event) do
    case generate_id(event) do
      {:ok, id} -> id
      {:error, error} -> raise error
    end
  end

  @doc """
  Encode the event struct to json string.

  """
  @impl true
  @spec to_json(event :: Event.t()) :: String.t()
  def to_json(event) do
    event
    |> Jason.encode!()
  end

  @doc """

  """
  @impl true
  @spec from_json(event_json :: String.t()) :: t
  def from_json(event_json) do
    event = Jason.decode!(event_json)

    %Event{
      id: event["id"] || "",
      pubkey: event["pubkey"] || "",
      created_at: event["created_at"] || 0,
      kind: event["kind"] || 0,
      tags: event["tags"] || [],
      content: event["content"] || "",
      sig: event["sig"] || ""
    }
  end
end
