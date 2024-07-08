defmodule ToyDns.Tutorial.Part2 do
  @moduledoc false

  alias ToyDns.Tutorial.Utils
  import ToyDns.Tutorial.Part1

  def build_dns_record(opts \\ []) do
    kws = [
      name: nil,
      type: nil,
      class: 1,
      ttl: 120,
      data: nil
    ]

    ordered_kw_combine(kws, opts)
  end

  def parse_header(response) do
    keys = build_dns_header() |> Keyword.keys()
    <<bin_header::binary-size(12), rest::binary>> = response
    {:ok, values} = Utils.struct_unpack(bin_header, "!HHHHHH", keys)
    values = Enum.map(values, fn x -> :binary.decode_unsigned(x) end)
    header = build_dns_header() |> Keyword.keys() |> Enum.zip(values)
    {header, rest}
  end

  def decode_name_simple(name) do
    {values, rest} = do_decode_name_simple(name, [])
    values = Enum.join(values, ".")
    {values, rest}
  end

  defp do_decode_name_simple(name, acc) do
    case name do
      <<0::integer-size(8), rest::binary>> ->
        IO.puts("SHOULD END NOW")
        {acc, rest}

      <<len::integer-size(8), rest::binary>> ->
        IO.inspect(len, label: "len", binaries: :as_binary)
        {result, rest} = read_bytes(rest, len)
        do_decode_name_simple(rest, acc ++ [result])
    end
  end

  def decode_name(name) do
    {values, rest} = do_decode_name(name, [])
    values = Enum.join(values, ".")
    {values, rest}
  end

  defp do_decode_name(name, acc) do
    case name do
      <<0::integer-size(8), rest::binary>> ->
        IO.puts("SHOULD END NOW")
        {acc, rest}

      <<0b11::size(2), bytes_rest::integer-size(6), len::integer-size(8), rest::binary>> ->
        # IO.inspect(len, label: "len_compr", binaries: :as_binary)
        # {result, rest} = read_bytes(rest, len)
        # do_decode_name(rest, acc ++ [result])
        bytes_rest |> IO.inspect(label: "bytes rest", binaries: :as_binary)
        len |> IO.inspect(label: "len", binaries: :as_binary)
        rest |> IO.inspect(label: "rest", binaries: :as_binary)
        pointer = bytes_rest + len
        <<_prev::binary-size(pointer), read_rest::binary>> = rest
        read_rest |> IO.inspect(label: "read rest", binaries: :as_binary)
        {new_acc, _new_rest} = do_decode_name(read_rest, [])
        {acc ++ new_acc, rest}

      <<len::integer-size(8), rest::binary>> ->
        # IO.inspect(len, label: "len", binaries: :as_binary)
        {result, rest} = read_bytes(rest, len)
        do_decode_name_simple(rest, acc ++ [result])
    end
  end

  defp decode_compressed_name(length, reader) do
    bytes_rest |> IO.inspect(label: "bytes rest", binaries: :as_binary)
    len |> IO.inspect(label: "len", binaries: :as_binary)
    rest |> IO.inspect(label: "rest", binaries: :as_binary)
    pointer = bytes_rest + len
    <<_prev::binary-size(pointer), read_rest::binary>> = rest
    read_rest |> IO.inspect(label: "read rest", binaries: :as_binary)
    {new_acc, _new_rest} = do_decode_name(read_rest, [])
    {acc ++ new_acc, rest}
  end

  defp read_bytes(string, len) do
    <<result::binary-size(len), rest::binary>> = string
    {result, rest}
  end

  def parse_question(response) do
    {name, rest} = decode_name_simple(response)
    <<bin_question::binary-size(4), rest::binary>> = rest
    keys = build_dns_question() |> Keyword.keys() |> Enum.reject(fn x -> x in [:name] end)
    {:ok, values} = Utils.struct_unpack(bin_question, "!HH", keys, [:name])
    values = Enum.map(values, fn x -> :binary.decode_unsigned(x) end)
    question = keys |> Enum.zip(values)
    question = [name: name] ++ question
    {build_dns_question(question), rest}
  end

  def parse_record(response) do
    # {name, rest} = decode_name_simple(response)
    {name, rest} = decode_name(response)
    <<bin_record::binary-size(10), rest::binary>> = rest
    keys = build_dns_record() |> Keyword.keys() |> Enum.reject(fn x -> x in [:name] end)
    {:ok, values} = Utils.struct_unpack(bin_record, "!HHIH", keys, [:name])
    values = Enum.map(values, fn x -> :binary.decode_unsigned(x) end)
    record = build_dns_record() |> Keyword.keys() |> Enum.zip(values)
    record = [name: name] ++ record
    {record, rest}
  end

  def test do
    response = send_query("www.example.com")
    {header, rest} = parse_header(response)
    {question, rest} = parse_question(rest)
    {record, rest} = parse_record(rest)
    # {header, question, rest}
    {header, question, record, rest}
  end
end
