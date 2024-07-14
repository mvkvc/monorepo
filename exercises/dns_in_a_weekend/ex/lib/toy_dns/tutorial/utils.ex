defmodule ToyDns.Tutorial.Utils do
  @moduledoc """
  This module contains utilities to replace functions used in the tutorial not available in Elixir.
  """

  def struct_pack(struct, pattern, exclude \\ [])

  def struct_pack(struct, pattern, exclude) when is_list(struct) do
    values =
      struct
      |> Keyword.drop(exclude)
      |> Keyword.values()

    {values, pattern} =
      case pattern do
        "!" <> rest -> {values, rest}
        rest -> {Enum.reverse(values), rest}
      end

    do_struct_pack(values, pattern, <<>>)
  end

  def struct_pack(_, _, _), do: {:error, :invalid_argument}

  defp do_struct_pack([], _, acc), do: {:ok, acc}
  defp do_struct_pack(_values, "", acc), do: {:ok, acc}

  defp do_struct_pack([h | t], pattern, acc) do
    case pattern do
      "H" <> rest ->
        do_struct_pack(t, rest, acc <> <<h::size(16)>>)

      "I" <> rest ->
        do_struct_pack(t, rest, acc <> <<h::size(32)>>)

      _ ->
        {:error, :unsupported_pattern}
    end
  end

  def struct_unpack(binary, pattern, keys, exclude \\ [])

  def struct_unpack(binary, pattern, keys, exclude) when is_binary(binary) do
    keys = Enum.reject(keys, fn x -> x in exclude end)

    {binary, pattern} =
      case pattern do
        "!" <> rest -> {binary, rest}
        rest -> {String.reverse(binary), rest}
      end

    # values = do_struct_unpack(binary, pattern, [])
    do_struct_unpack(binary, pattern, [])
    # Enum.zip(keys, values)
  end

  def struct_unpack(_, _, _, _), do: {:error, :invalid_argument}

  def do_struct_unpack("", _pattern, acc), do: {:ok, acc}
  def do_struct_unpack(_binary, "", acc), do: {:ok, acc}

  def do_struct_unpack(binary, pattern, acc) do
    case pattern do
      "H" <> rest ->
        <<bin_value::binary-size(2), bin_rest::binary>> = binary
        # value = Base.decode16!(bin_value)
        value = bin_value
        do_struct_unpack(bin_rest, rest, acc ++ [value])

      "I" <> rest ->
        <<bin_value::binary-size(4), bin_rest::binary>> = binary
        # value = Base.decode16!(bin_value)
        value = bin_value
        do_struct_unpack(bin_rest, rest, acc ++ [value])

      _ ->
        {:error, :unsupported_pattern}
    end
  end
end
