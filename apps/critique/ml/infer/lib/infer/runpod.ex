defmodule Infer.Runpod do
  def encode(input) do
    input
    |> Enum.map(fn x -> Map.values(x)
    |> Enum.join(":") end)
    |> Enum.join(",")
  end

  def decode(input) do
    input
    |> String.split(",")
    |> Enum.map(fn x -> String.split(x, ":") end)
    |> Enum.map(fn x -> Enum.zip([:id, :link], x) end)
    |> Enum.map(fn x -> Enum.into(x, %{}) end)
  end
end
