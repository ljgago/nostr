# Nostr

Nostr is a package that implements the Nostr protocol and a set of tools for Elixir.
This package implement a NIF using [rustler](https://github.com/rusterlium/rustler),
and uses libraries from [rust-bitcoin](https://github.com/rust-bitcoin) project.

NIPs implementated:

- [x] NIP-01: Basic protocol flow description
- [x] NIP-19: bech32-encoded entities

## Instalation

```elixir
def deps do
  [
    {:nostr, git: "https://github.com/ljgago/nostr"}
  ]
end
```

## Usage

Nostr is divided by functionality and implement the following modules:

- `Nostr.KeyPair`
- `Nostr.PublicKey`
- `Nostr.SecretKey`
- `Nostr.Event`
- `Nostr.Message`
- `Nostr.Metadata`

Geneate a radom key pair:

```elixir
iex> Nostr.KeyPair.new()
%{
  pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
  seckey: "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d"
}
```

Generate a bech32 public key:

```elixir
iex> Nostr.PublicKey.encode("718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029")
{:ok, "npub1wxxh2mmqeaghnme4kwwudkel7k8sfsrnf7qld4zppu9sglwljq5shd0y24"}
```

Sig a event:

```elixir
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
```

Verify the event signature:

```elixir
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
```

## License

[MIT License](LICENSE)
