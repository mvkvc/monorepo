defmodule Stack do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  def push(pid, element) do
    GenServer.call(pid, {:push, element})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  def get_stack(pid) do
    GenServer.call(pid, :get_stack)
  end

  @impl true
  def init(stack \\ []) do
    {:ok, stack}
  end

  @impl true
  def handle_call({:push, element}, _from, state) do
    new_state = [element | state]
    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call(:pop, _from, []) do
    {:reply, [], []}
  end

  @impl true
  def handle_call(:pop, _from, state) do
    [element | new_state] = state
    {:reply, element, new_state}
  end

  @impl true
  def handle_call(:get_stack, _from, state) do
    {:reply, state, state}
  end
end
