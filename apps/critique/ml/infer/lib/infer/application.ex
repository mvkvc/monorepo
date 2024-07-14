defmodule Infer.Application do
  require Logger
  use Application

  @port 4001

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Infer, port: @port}
    ]

    Logger.info("Starting Infer application on port #{@port}")

    opts = [strategy: :one_for_one, name: Infer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
