defmodule Nostr.KeyPairTest do
  use ExUnit.Case
  doctest Nostr.KeyPair, except: [new: 0]

  alias Nostr.KeyPair

  @key_pair %{
    pubkey: "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029",
    seckey: "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d"
  }

  test "get key pair from secret key" do
    assert KeyPair.from_secret_key(@key_pair.seckey) == {:ok, @key_pair}

    bad_seckey = "aa5aaf09a301e3a9903bd4d041a1e1d63d3e"
    assert KeyPair.from_secret_key(bad_seckey) == {:error, "malformed secret key"}
  end
end
