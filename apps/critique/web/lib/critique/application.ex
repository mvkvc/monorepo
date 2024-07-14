defmodule Critique.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CritiqueWeb.Telemetry,
      # Start the Ecto repository
      Critique.Repo,
      # Start the PubSub system
      # {Phoenix.PubSub, name: Critique.PubSub},
      {Phoenix.PubSub, [name: Critique.PubSub, adapter: Phoenix.PubSub.PG2]},
      # Start Finch
      {Finch, name: Critique.Finch},
      # Start the Endpoint (http/https)
      CritiqueWeb.Endpoint,
      # Start a worker by calling: Critique.Worker.start_link(arg)
      # {Critique.Worker, arg},
      {Task.Supervisor, name: Critique.TaskSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Critique.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CritiqueWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
