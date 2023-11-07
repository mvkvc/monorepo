import Lbdev

defmodule M do
  Lbdev.def_sig([
    {:f, [:a, :b]},
    {:g, [:x, :y, :z]}
  ])
end

# Lbdev.def_impl M, f(x, y) do
#   x + y
# end

# expr = M.f(10, 20)
# IO.inspect("ADDING: #{expr}")

# Lbdev.def_impl M, f(x, y) do
#   x - y
# end

# expr = M.f(10, 20)
# IO.inspect("SUBTRACT: #{expr}")

# Lbdev.def_impl M, g(x, y, z) do
#   x * y * z
# end

# expr = M.g(2, 3, 4)
# IO.inspect("MULTIPLY: #{expr}")

# Lbdev.def_impl M, g(x, y, z) do
#   x ** y ** z
# end

# expr = M.g(2, 3, 4)
# IO.inspect("POWER: #{expr}")

proc = Process.get() |> IO.inspect(label: "proc")
