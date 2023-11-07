defmodule AOC.D1 do
    import AOC

    def p1(path \\ "./priv/d1.txt") do
        path
        |> read_lines()
        |> Enum.map(fn line -> take_numeric(line) end)
        |> Enum.sum()
      end
    
      # Change this to return one number in either 1/one format
      # Take one then flip and take other
      # Change extract numerics to first look for all possible strings then do other piece
    
      # Should always contain
      # defp take_numeric("", len) do
      # end
    
      def list_to_number(acc), do: (List.first(acc) <> List.last(acc)) |> String.to_integer()
    
      def take_numeric("", acc, len) do
        acc |> list_to_number()
      end
    
      def take_numeric(str, acc, 6) do
        take_numeric(String.slice(str, 1..-1), acc, 1)
      end
    
      def take_numeric(str, acc \\ [], len \\ 1) do
        {f, l} = String.split_at(str, len)
        IO.inspect({str, f, l, acc, len}, label: "ROOT")
    
        cond do
          f in str_number() -> 
            IO.inspect(f, label: "STRNUMBER")
            take_numeric(String.slice(str, 1..-1), acc ++ [f], 1)
          Map.has_key?(str_numeric(), f) -> 
            IO.inspect(f, label: "STRNUMERIC")
            # THIS RETURNS THE KEY FOR SOME REASON
            value = Map.fetch!(str_numeric(), f)
            IO.inspect(value, label: "STRNUMERIC VALUE")
            take_numeric(String.slice(str, 1..-1), acc ++ [value], 1)
          true -> take_numeric(str, acc, len + 1)
        end
      end
    
      def str_number(), do: 0..9 |> Enum.map(fn n -> Integer.to_string(n) end)
      def str_numeric(), do: ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"] |> Enum.zip(str_number()) |> Map.new(fn {k, v} -> {k, v} end)
    
      # defp extract_numerics(str) when is_binary(str) do
      #   str
      #   |> String.split("", trim: true)
      #   |> extract_numerics([])
      # end
    
      # defp extract_numerics([], acc), do: (List.first(acc) <> List.last(acc)) |> String.to_integer()
    
      # defp extract_numerics([h | t], acc) do
      #   case Integer.parse(h) do
      #     {_integer, _decimal_str} -> extract_numerics(t, acc ++ [h])
      #     _ -> extract_numerics(t, acc)
      #   end
      # end
end