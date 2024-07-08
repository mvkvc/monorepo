defmodule KinoExperiment.Application do
  use Application

  @impl true
  def start(_type, _args) do
    Kino.SmartCell.register(KinoExperiment)

    children = []

    opts = [strategy: :one_for_one, name: KinoExperiment.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
