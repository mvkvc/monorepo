defmodule Counter.Count do
  def get do
    GenServer.call(Counter.Count.CountServer, :get)
  end
  def increment(increment_by \\ 1) do
    GenServer.call(Counter.Count.CountServer, {:increment, increment_by})
  end
end
