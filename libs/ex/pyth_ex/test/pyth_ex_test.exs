defmodule PythExTest do
  use ExUnit.Case
  doctest PythEx

  test "greets the world" do
    assert PythEx.hello() == :world
  end
end
