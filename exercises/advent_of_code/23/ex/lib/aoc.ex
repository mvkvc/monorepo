defmodule AOC do
  def read_lines(path) do
    path
    |> Path.expand()
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end
end
