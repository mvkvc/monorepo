defmodule ToyDns.Tutorial.Part1 do
  @moduledoc false

  alias ToyDns.Tutorial.Utils
  import Bitwise

  @type_a 1
  @class_in 1
  @udp_port 5001
  @dns_port 53
  @timeout 2_000

  def ordered_kw_combine(kw1, kw2) do
    kw2_map = Map.new(kw2)

    Enum.map(kw1, fn {k, v} ->
      if Map.has_key?(kw2_map, k) do
        {k, Map.get(kw2_map, k)}
      else
        {k, v}
      end
    end)
  end

  def build_dns_header(opts \\ []) do
    kws = [
      id: nil,
      flags: nil,
      num_questions: 0,
      num_answers: 0,
      num_authorities: 0,
      num_additional: 0
    ]

    ordered_kw_combine(kws, opts)
  end

  def build_dns_question(opts \\ []) do
    kws = [name: nil, type: nil, class: nil]

    ordered_kw_combine(kws, opts)
  end

  def header_to_bytes(header) do
    id = Keyword.get(header, :id)

    case Utils.struct_pack(header, "!HHHHH", [:id]) do
      {:ok, packed} ->
        # <<id::size(16)>> <> packed |> IO.inspect(binaries: :as_binaries)
        {:ok, <<id::size(16)>> <> packed}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def question_to_bytes(question) do
    name = Keyword.get(question, :name)

    case Utils.struct_pack(question, "!HH", [:name]) do
      {:ok, packed} -> {:ok, name <> packed}
      {:error, reason} -> {:error, reason}
    end
  end

  def encode_dns_name(domain) do
    domain
    |> String.split(".")
    |> Enum.map_join(fn part -> <<String.length(part)::8, part::binary>> end)
    |> Kernel.<>(<<0::8>>)
  end

  def build_query(domain, record_type, id \\ nil) do
    name = encode_dns_name(domain)
    id = if id, do: id, else: Enum.random(0..65_536)
    recursion_desired = 1 <<< 8

    header = build_dns_header(id: id, num_questions: 1, flags: recursion_desired)
    question = build_dns_question(name: name, type: record_type, class: @class_in)

    with {:ok, header_bytes} <- header_to_bytes(header),
         {:ok, question_bytes} <- question_to_bytes(question) do
      {:ok, header_bytes <> question_bytes}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def send_query(domain, server \\ "8.8.8.8") do
    server =
      server
      |> String.split(".")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    opts = [:binary, {:active, false}]
    {:ok, socket} = :gen_udp.open(@udp_port, opts)

    try do
      {:ok, query} = build_query(domain, @type_a, 8296)
      :ok = :gen_udp.send(socket, server, @dns_port, query)
      {:ok, {_, _, response}} = :gen_udp.recv(socket, 0, @timeout)
      response
    after
      :gen_udp.close(socket)
    end
  end
end
