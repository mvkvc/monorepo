defmodule RubixCubeTest do
  use ExUnit.Case
  doctest RubixCube

  test "greets the world" do
    assert RubixCube.hello() == :world
  end
end
