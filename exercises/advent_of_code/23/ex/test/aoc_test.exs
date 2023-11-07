defmodule AOCTest do
  use ExUnit.Case
  doctest AOC

  test "p1" do
    lines = AOC.read_lines("./priv/example.txt")
  end

  test "p2" do
    input = [
      "two1nine",
      "eightwothree",
      "abcone2threexyz",
      "xtwone3four",
      "4nineeightseven2",
      "zoneight234",
      "7pqrstsixteen"
    ]
    result = num.map(input, fn l -> AOC.extract_numerics(l) end)
    assert 
end
