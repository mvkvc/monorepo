defmodule KinoExp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    Kino.SmartCell.register(KinoExp)

    children = []

    opts = [strategy: :one_for_one, name: KinoExp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
