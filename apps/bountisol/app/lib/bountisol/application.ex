defmodule Bountisol.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Oban.Telemetry.attach_default_logger()

    children = [
      BountisolWeb.Telemetry,
      Bountisol.Repo,
      {DNSCluster, query: Application.get_env(:bountisol, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Bountisol.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Bountisol.Finch},
      # Start a worker by calling: Bountisol.Worker.start_link(arg)
      # {Bountisol.Worker, arg},
      # Start to serve requests, typically the last entry
      BountisolWeb.Endpoint,
      BountisolWeb.Presence,
      {Oban, Application.fetch_env!(:bountisol, Oban)},
      Portboy.child_pool(
        :js,
        {System.find_executable("node"), [Path.join(:code.priv_dir(:bountisol), "/ports/js/main.cjs")]},
        5,
        2
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bountisol.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BountisolWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
