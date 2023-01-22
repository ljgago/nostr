defmodule Nostr.EventTest do
  use ExUnit.Case
  doctest Nostr.Event, except: [sign: 2, sign!: 2]

  alias Nostr.Event

  @event %Event{
    id: "2798df6067fb67f1e59a66f9fc97c69d052777ee0f8421fe643ecf5001573c7d",
    pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
    created_at: 1_671_028_682,
    kind: 4,
    tags: [
      ["p", "f8340b2bde651576b75af61aa26c80e13c65029f00f7f64004eece679bf7059f"]
    ],
    content: "Hello world!",
    sig:
      "9f01b0a6e178f80749a0a9599bb5fdd5a6b976421bcc26fe9fd9b8f3f106d90fceb5f250ab2a7ed42f925077acf1876803810bfcb26e9fca60d08da1b2286d63"
  }

  test "verify the event signature" do
    changed_event = struct(@event, content: "Hello", kind: 3)
    assert Event.verify(changed_event) == {:ok, false}
  end
end
