defmodule Counter.Count.CountServer do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:increment, increment_by}, _from, state) do
    new_state = state + increment_by
    {:reply, new_state, new_state}
  end
end
