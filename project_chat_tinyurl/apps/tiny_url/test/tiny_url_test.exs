defmodule TinyURLTest do
  use ExUnit.Case
  doctest TinyURL

  test "greets the world" do
    assert TinyURL.hello() == :world
  end
end
