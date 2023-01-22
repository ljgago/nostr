defmodule Nostr.PublicKeyTest do
  use ExUnit.Case
  doctest Nostr.PublicKey

  alias Nostr.PublicKey

  @pubkey "718d756f60cf5179ef35b39dc6db3ff58f04c0734f81f6d4410f0b047ddf9029"
  @seckey "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d"

  test "get public key from secret key" do
    assert PublicKey.from_secret_key(@seckey) == {:ok, @pubkey}
  end
end
