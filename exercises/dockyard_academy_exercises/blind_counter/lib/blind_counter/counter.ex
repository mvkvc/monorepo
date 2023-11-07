defmodule BlindCounter.Counter do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def increment do
    GenServer.call(__MODULE__, :increment)
  end

  def init([]) do
    {:ok, 0}
  end

  def handle_call(:increment, _from, state) do
    new_state = state + 1
    {:reply, new_state, new_state}
  end
end
