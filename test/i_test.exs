defmodule ITest do
  use ExUnit.Case
  doctest I

  test "greets the world" do
    assert I.hello() == :world
  end
end
