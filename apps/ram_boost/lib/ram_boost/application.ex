defmodule RB.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RBWeb.Telemetry,
      RB.Repo,
      {DNSCluster, query: Application.get_env(:ram_boost, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RB.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: RB.Finch},
      # Start a worker by calling: RB.Worker.start_link(arg)
      # {RB.Worker, arg},
      # Start to serve requests, typically the last entry
      RBWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RB.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RBWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
