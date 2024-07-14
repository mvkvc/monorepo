defmodule Walter.Supervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @impl true
  def init(_init) do
    children = [
      Walter.Consumer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
