defmodule Lbdev do
  defmacro def_impl(mod, call, do: block) do
    {fun_name, context, args} = call
    arity = length(args)

    ast = Macro.escape(block)

    quote do
      f = fn unquote_splicing(args) ->
        unquote(block)
      end

      Process.put({unquote(mod), unquote(fun_name), unquote(arity), :ast}, unquote(ast))

      Process.put({unquote(mod), unquote(fun_name), unquote(arity)}, f)

      :ok
    end
  end

  defmacro def_sig(functions) do
    for {name, args} <- functions do
      arity = length(args)
      args = for i <- args, do: {i, [], Elixir}

      quote do
        def unquote(name)(unquote_splicing(args)) do
          impl =
            Process.get({__MODULE__, unquote(name), unquote(arity)}, fn unquote_splicing(args) ->
              raise "not implemented"
            end)

          impl.(unquote_splicing(args))
        end
      end
    end
  end

  def get_module_ast(module_name) do
    ast_list =
      Process.get()
      |> Enum.filter(fn {pid, _} -> pid == self() end)
      |> hd()
      |> Process.info(:dictionary)
      |> Enum.filter(fn {k, _} -> is_tuple(k) and elem(0, k) == module_name end)
      |> Enum.map(fn {{module_name, fname, arity, :ast}, ast} -> {fname, arity, ast} end)

    quote do
      defmodule unquote(module_name) do
        (unquote_splicing(ast_list))
      end
    end
  end
end

# defmodule Lbdev do
#   defmacro define_implementation(mod, call, do: block) do
#     {fun_name, _context, args} = call
#     arity = length(args)

#     ast = Macro.escape(block)

#     quote do
#       f = fn unquote_splicing(args) ->
#         unquote(block)
#       end

#       Process.put({unquote(mod), unquote(fun_name), unquote(arity), :ast}, unquote(ast))

#       Process.put({unquote(mod), unquote(fun_name), unquote(arity)}, f)

#       :ok
#     end
#   end

#   defmacro generate_functions(functions) do
#     for {name, arity} <- functions do
#       args = for i <- 0..(arity - 1), do: {String.to_atom("arg#{i}"), [], Elixir}

#       quote do
#         def unquote(name)(unquote_splicing(args)) do
#           impl =
#             Process.get({__MODULE__, unquote(name), unquote(arity)}, fn unquote_splicing(args) ->
#               raise "not implemented"
#             end)

#           impl.(unquote_splicing(args))
#         end
#       end
#     end
#   end

#   def get_module_ast(module_name) do
#     ast_list =
#       Process.get()
#       # |> IO.inspect()
#       # |> Enum.filter(fn {pid, _} -> pid == self() end)
#       # |> IO.inspect()
#       # |> hd()
#       # |> IO.inspect()
#       # |> Process.info(:dictionary)
#       |> IO.inspect(label: "proc")
#       |> Enum.filter(fn {k, _} ->
#         is_tuple(k) and elem(k, 0) == module_name and tuple_size(k) == 4
#       end)
#       |> IO.inspect(label: "filter")
#       |> Enum.map(fn {{_module_name, fname, arity, :ast}, ast} -> {fname, arity, ast} end)

#     quote do
#       defmodule unquote(module_name) do
#         (unquote_splicing(ast_list))
#       end
#     end
#   end
# end
