defmodule ToyDns.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      ToyDns.Server
    ]

    opts = [strategy: :one_for_one, name: ToyDns.Server]
    Supervisor.start_link(children, opts)
  end
end
