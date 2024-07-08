defmodule EETest do
  use ExUnit.Case
  doctest EE

  test "greets the world" do
    assert EE.hello() == :world
  end
end
