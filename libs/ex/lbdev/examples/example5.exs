ast1 =
  quote do
    def x(a, b) do
      a + b
    end
  end

ast2 =
  quote do
    defmodule M do
      def x(a, b) do
        a + b
      end
    end
  end

ast3 =
  quote do
    defmodule M do
      def x(a, b) do
        a + b
      end
      defn y(x, y, z) do
        x * y * z
      end
    end
  end

ast1 |> IO.inspect(label: "ast1")
ast2 |> IO.inspect(label: "ast2")
ast3 |> IO.inspect(label: "ast3")

# {:defmodule, [context: Elixir, imports: [{2, Kernel}]],
#  [
#    {:__aliases__, [alias: false], [:M]},
#    [
#      do: subast2
#    ]
#  ]} = ast2

# subast2 |> IO.inspect()
# ast1 |> IO.inspect()
# IO.inspect(subast2 == ast1)
