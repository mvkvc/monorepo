import Lbdev

defmodule M do
  Lbdev.def_sig([
    {:f, [:a, :b]},
    {:g, [:x, :y, :z]}
  ])
end

Lbdev.define_impl M, f(x, y) do
  defn f(x, y) do
    x + y
  end
end

# Lbdev.define_impl M, f(x, y), do
#     x - y
# end

proc = Process.get()
proc |> IO.inspect()

# expr = M.f(10, 20)
# IO.inspect("ADDING: #{expr}")

# Lbdev.define_implementation M, f(x, y) do
#   x - y
# end

# expr = M.f(10, 20)
# IO.inspect("SUBTRACT: #{expr}")

# Lbdev.define_implementation M, g(x, y, z) do
#   x * y * z
# end

# expr = M.g(2, 3, 4)
# IO.inspect("MULTIPLY: #{expr}")

# Lbdev.define_implementation M, g(x, y, z) do
#   x ** y ** z
# end

# expr = M.g(2, 3, 4)
# IO.inspect("POWER: #{expr}")
