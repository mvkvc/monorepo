defmodule NanoGpt.Data do
  import Nx

  def stream_binary(path, opts \\ []) do
    bits = Keyword.get(opts, :bits, 16)

    bytes = div(bits, 8)

    path
    |> File.stream!([], bytes)
    |> Stream.map(&:binary.decode_unsigned(&1, :little))
  end

  def stream_batches(stream, opts \\ []) do
    length = Keyword.get(opts, :length, 1000)
    offset = Keyword.get(opts, :offset, 1)
    batch_size = Keyword.get(opts, :batch_size, 64)

    stream
    |> Stream.chunk_every(length, offset, :discard)
    |> Stream.chunk_every(batch_size, 1)
    |> (fn x -> Stream.zip(x, Stream.drop(x, 1)) end).()
    |> Stream.map(fn {batch, offset} -> {tensor(batch), tensor(offset)} end)
  end
end
