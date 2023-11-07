defmodule MyMacro do
  defmacro define_implementation(mod, call, do: block) do
    {fun_name, context, args} = call
    
    IO.inspect(fun_name)
    arity = length(args)
    
    quote do
      f = fn unquote_splicing(args) ->
        unquote(block)
      end
      Process.put({unquote(mod), unquote(fun_name), unquote(arity)}, f)
      :ok
    end
  end
end

import MyMacro

defmodule M do
  def f(x, y) do
    impl = Process.get({__MODULE__, :f, 2}, fn x, y -> raise "not implemented" end)
    impl.(x, y)
  end
end

MyMacro.define_implementation M, f(x, y) do
  x + y
end

add = M.f(10, 10)
IO.inspect("ADDING: #{add}")

define_implementation M, f(x, y) do
  x - y
end

subtract = M.f(10, 20)
IO.inspect("SUBTRACT: #{subtract}")

# iex(1)> 
# nil
# iex(2)> 
# nil
# iex(3)> 
# nil
# iex(4)> quote do 
# ...(4)> fn x, y -> 
# ...(4)> x + y
# ...(4)> end
# ...(4)> end
# {:fn, [],
#  [
#    {:->, [],
#     [
#       [{:x, [], Elixir}, {:y, [], Elixir}],
#       {:+, [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]],
#        [{:x, [], Elixir}, {:y, [], Elixir}]}
#     ]}
#  ]}
# iex(5)> quote do
# ...(5)> def f(x, y) do
# ...(5)> x + y
# ...(5)> end
# ...(5)> end
# {:def, [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]],
#  [
#    {:f, [context: Elixir], [{:x, [], Elixir}, {:y, [], Elixir}]},
#    [
#      do: {:+, [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]],
#       [{:x, [], Elixir}, {:y, [], Elixir}]}
#    ]
#  ]}
# iex(6)> defmodule M do
# ...(6)> def f(x, y) do
# ...(6)> :persistent_term.get
# get/0    get/1    get/2    
# ...(6)> :persistent_term.get(M, fn x, y -> raise "not implemented" end)
# ...(6)> end
# ...(6)> end
# warning: variable "x" is unused (there is a variable with the same name in the context, use the pin operator (^) to match on it or prefix this variable with underscore if it is not meant to be used)
#   iex:8: M.f/2

# warning: variable "y" is unused (there is a variable with the same name in the context, use the pin operator (^) to match on it or prefix this variable with underscore if it is not meant to be used)
#   iex:8: M.f/2

# warning: variable "x" is unused (if the variable is not meant to be used, prefix it with an underscore)
#   iex:7: M.f/2

# warning: variable "y" is unused (if the variable is not meant to be used, prefix it with an underscore)
#   iex:7: M.f/2

# {:module, M,
#  <<70, 79, 82, 49, 0, 0, 6, 216, 66, 69, 65, 77, 65, 116, 85, 56, 0, 0, 0, 234,
#    0, 0, 0, 24, 8, 69, 108, 105, 120, 105, 114, 46, 77, 8, 95, 95, 105, 110,
#    102, 111, 95, 95, 10, 97, 116, 116, 114, ...>>, {:f, 2}}
# iex(7)> M.f(1, 2)
# #Function<0.133681586/2 in M.f/2>
# iex(8)> M.f(1, 2)defmodule M do
# ...(8)>   def f(x, y) do
# ...(8)>     impl = :persistent_term.get(M, fn x, y -> raise "not implemented" end)
# ...(8)>     impl.(x, y)
# ...(8)>   end
# ...(8)> end
# ** (SyntaxError) iex:8:10: syntax error before: defmodule
#     |
#   8 | M.f(1, 2)defmodule M do
#     |          ^

# iex(8)> 
# nil
# iex(9)> defmodule M do
# ...(9)>   def f(x, y) do
# ...(9)>     impl = :persistent_term.get(M, fn x, y -> raise "not implemented" end)
# ...(9)>     impl.(x, y)
# ...(9)>   end
# ...(9)> end
# warning: redefining module M (current version defined in memory)
#   iex:9

# warning: variable "x" is unused (there is a variable with the same name in the context, use the pin operator (^) to match on it or prefix this variable with underscore if it is not meant to be used)
#   iex:11: M.f/2

# warning: variable "y" is unused (there is a variable with the same name in the context, use the pin operator (^) to match on it or prefix this variable with underscore if it is not meant to be used)
#   iex:11: M.f/2

# {:module, M,
#  <<70, 79, 82, 49, 0, 0, 7, 32, 66, 69, 65, 77, 65, 116, 85, 56, 0, 0, 0, 234,
#    0, 0, 0, 24, 8, 69, 108, 105, 120, 105, 114, 46, 77, 8, 95, 95, 105, 110,
#    102, 111, 95, 95, 10, 97, 116, 116, 114, ...>>, {:f, 2}}
# iex(10)> 
# nil
# iex(11)> M.f(1, 2)
# ** (RuntimeError) not implemented
#     iex:11: anonymous fn/2 in M.f/2
# iex(11)> :persistent_term.put(M, &+/2)
# :ok
# iex(12)> M.f(1, 2)                    
# 3
# iex(13)> defmodule M do
# ...(13)>   def f(x, y) do
# ...(13)>     impl = Process.get({:f, 2}, fn x, y -> raise "not implemented" end)
# ...(13)>     impl.(x, y)
# ...(13)>   end
# ...(13)> end
# warning: redefining module M (current version defined in memory)
#   iex:13

# warning: variable "x" is unused (there is a variable with the same name in the context, use the pin operator (^) to match on it or prefix this variable with underscore if it is not meant to be used)
#   iex:15: M.f/2

# warning: variable "y" is unused (there is a variable with the same name in the context, use the pin operator (^) to match on it or prefix this variable with underscore if it is not meant to be used)
#   iex:15: M.f/2

# {:module, M,
#  <<70, 79, 82, 49, 0, 0, 7, 44, 66, 69, 65, 77, 65, 116, 85, 56, 0, 0, 0, 233,
#    0, 0, 0, 24, 8, 69, 108, 105, 120, 105, 114, 46, 77, 8, 95, 95, 105, 110,
#    102, 111, 95, 95, 10, 97, 116, 116, 114, ...>>, {:f, 2}}
# iex(14)> M.f(1, 2)
# ** (RuntimeError) not implemented
#     iex:15: anonymous fn/2 in M.f/2
# iex(14)> Process.put(self(), M, &+/2)                                           
# ** (UndefinedFunctionError) function Process.put/3 is undefined or private. Did you mean:

#       * put/2

#     (elixir 1.14.0) Process.put(#PID<0.110.0>, M, &:erlang.+/2)
# iex(14)> h Process.                  
# alive?/1          cancel_timer/1    cancel_timer/2    delete/1          
# demonitor/1       demonitor/2       exit/2            flag/2            
# flag/3            get/0             get/1             get/2             
# get_keys/0        get_keys/1        group_leader/0    group_leader/2    
# hibernate/3       info/1            info/2            link/1            
# list/0            monitor/1         put/2             read_timer/1      
# register/2        registered/0      send/3            send_after/3      
# send_after/4      sleep/1           spawn/2           spawn/4           
# unlink/1          unregister/1      whereis/1         
# iex(14)> h Process.put

#                               def put(key, value)                               

#   @spec put(term(), term()) :: term() | nil

# Stores the given key-value pair in the process dictionary.

# The return value of this function is the value that was previously stored under
# key, or nil in case no value was stored under it.

# ## Examples

#     # Assuming :locale was not set
#     iex> Process.put(:locale, "en")
#     nil
#     iex> Process.put(:locale, "fr")
#     "en"

# iex(15)> Process.put({:f, 2}, &+/2)  
# nil
# iex(16)> M.f(1, 2)                   
# 3
# iex(17)> spawn(fn -> Process.put({:f, 2}, &*/2); M.f(10, 20) |> IO.inspect() end)
# 200
# #PID<0.174.0>
# iex(18)> M.f(1, 2)                                                               
# 3
# iex(19)> :observer.start
# :ok
# iex(20)> self
# #PID<0.110.0>

# defmodule M do
#   def f(x, y) do
#     impl = Process.get({__MODULE__, :f, 2}, fn x, y -> raise "not implemented" end)
#     impl.(x, y)
#   end
# end

# defmodule MyMacro do
#   defmacro define_implementation(call, mod, do: block) do
#     {fun_name, context, args} = call
    
#     IO.inspect(fun_name)
#     arity = length(args)
    
#     quote do
#       f = fn unquote_splicing(args) ->
#         unquote(block)
#       end
#       Process.put({unquote(mod), unquote(fun_name), unquote(arity)}, f)
#       :ok
#     end
#   end
# end

# import MyMacro

# define_implementation f(x, y), M do
#   x + y
# end

# M.f(10, 10)


# define_implementation f(x, y), M do
#   x - y
# end

# M.f(10, 20)

# defmodule M do
#   def f(x, y) do
#     impl = Process.get({__MODULE__, :f, 2}, fn x, y -> raise "not implemented" end)
#     impl.(x, y)
#   end
# end