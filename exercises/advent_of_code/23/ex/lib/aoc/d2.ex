defmodule AOC.D2 do
    import AOC

    def p1(path \\ "./priv/d2.txt") do
        path
        |> read_lines()
        |> IO.inspect()
      end
end