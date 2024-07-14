defmodule AstToModule do
  def convert(ast) do
    {module_name, functions_ast} = extract_module_name_and_functions(ast)
    {:ok, module_binary} = build_module(module_name, functions_ast)
    Code.load_binary(module_name, module_binary)
  end

  defp extract_module_name_and_functions(ast) do
    module_name = Enum.random('A'..'Z') |> to_string()
    functions_ast = Enum.map(ast, &build_function_ast/1)
    {String.to_atom(module_name), functions_ast}
  end

  defp build_function_ast({{module_name, function_name, arity, _}, ast_body}) do
    {:def, [], [build_function_head(function_name, arity), [do: ast_body]]}
  end

  defp build_function_head(function_name, arity) do
    args = Enum.map(0..(arity - 1), &{:arg_#{&1}, [], Elixir})
    {:function_name, [], args}
  end

  defp build_module(module_name, functions_ast) do
    module_ast = {
      :defmodule,
      [],
      [
        {:__aliases__, [alias: false], [String.to_atom(module_name)]},
        [do: {:__block__, [], functions_ast}]
      ]
    }
    Code.compile_quoted([module_ast])
  end
end

ast = [
  {{:M, :f, 2, [ARGUMENTS] :ast},
   {:-, [line: 18], [{:x, [line: 18], nil}, {:y, [line: 18], nil}]}},
  {{:M, :g, 3, :ast},
   {:**, [line: 33],
    [
      {:**, [line: 33], [{:x, [line: 33], nil}, {:y, [line: 33], nil}]},
      {:z, [line: 33], nil}
    ]}}
]

{:module, module_name, binary, _} = AstToModule.convert(ast)

IO.inspect(module_name) # This will print the generated module name
IO.inspect apply(module_name, :f, [2, 3]) # This will call the generated function `f/2` with arguments 2 and 3
IO.inspect apply(module_name, :g, [2, 3, 4]) # This will call the generated function `g/3` with arguments 2, 3, and 4
