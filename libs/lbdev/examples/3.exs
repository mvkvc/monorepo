defmodule ASTConverter do
  def convert(ast) do
    module_definition = generate_module_definition(ast)
    Code.eval_string(module_definition)
  end

  defp generate_module_definition(ast) do
    functions = Enum.map(ast, &generate_function/1)

    """
    defmodule M do
      #{Enum.join(functions)}
    end
    """
  end

  defp generate_function({{_, name, arity, _}, ast}) do
    args = Enum.map(1..arity, &"arg_#{&1}")
    formatted_args = Enum.join(args, ", ")

    """
    def #{name}(#{formatted_args}) do
      unquote(ast)
    end
    """
  end
end

# ast = [
#   {{M, :f, 2, :ast},
#    {:-, [line: 18], [{:x, [line: 18], nil}, {:y, [line: 18], nil}]}},
#   {{M, :g, 3, :ast},
#    {:**, [line: 33],
#     [
#       {:**, [line: 33], [{:x, [line: 33], nil}, {:y, [line: 33], nil}]},
#       {:z, [line: 33], nil}
#     ]}}
# ]

ASTConverter.convert(ast)

# Usage examples
IO.inspect(M.f(10, 5)) # Should output 5
IO.inspect(M.g(2, 3, 2)) # Should output 64
