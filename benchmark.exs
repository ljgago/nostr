list = Enum.to_list(1..10_000)
map_fun = fn i -> [i, i * i] end

event = %Nostr.Event{
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


Benchee.run(%{
  # "Nostr.KeyPair.new" => fn -> Enum.map(0..10_000, fn _ -> Nostr.KeyPair.new() end) end,
  # "Nostr.PublicKey.encode" => fn -> Enum.map(0..10_000, fn _ -> Nostr.PublicKey.encode("718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029") end) end,
  # "Nostr.Event.serialize" => fn -> Enum.map(0..1_000_000, fn _ -> Nostr.Event.serialize(event) end) end,
  # "Nostr.Event.serialize2" => fn -> Enum.map(0..1_000_000, fn _ -> Nostr.Event.serialize2(event) end) end,
  # "Nostr.Event.serialize" => fn -> Nostr.Event.serialize(event) end,
  # "Nostr.Event.serialize2" => fn -> Nostr.Event.serialize2(event) end,
  # "None" => fn -> Enum.map(0..10_000, fn _ ->  end) end,
  # "Nostr.Event.sign" => fn -> Enum.map(0..10_000, fn _ -> Nostr.Event.sign(event, "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d") end) end,
  # "Nostr.Event.sign2" => fn -> Enum.map(0..10_000, fn _ -> Nostr.Event.sign2(event, "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d") end) end,
  # "Nostr.Event.verify" => fn -> Nostr.Event.verify(event) end,
  # "Nostr.Event.verify2" => fn -> Nostr.Event.verify2(event) end,
}, parallel: 4)
