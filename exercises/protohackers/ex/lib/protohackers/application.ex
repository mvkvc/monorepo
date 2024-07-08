defmodule Protohackers.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Protohackers.Echo,
      Protohackers.Prime,
      Protohackers.Means
    ]

    opts = [strategy: :one_for_one, name: Protohackers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
