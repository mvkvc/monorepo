defmodule TreeFi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TreeFiWeb.Telemetry,
      TreeFi.Repo,
      {DNSCluster, query: Application.get_env(:treefi, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TreeFi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TreeFi.Finch},
      # Start a worker by calling: TreeFi.Worker.start_link(arg)
      # {TreeFi.Worker, arg},
      # Start to serve requests, typically the last entry
      TreeFiWeb.Endpoint,
      TreeFi.Prices,
      Portboy.child_pool(:merkle, {System.find_executable("node"), [Path.join(:code.priv_dir(:treefi), "/portboy/merkle_noir/out/main.js")]}, 5, 2)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TreeFi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TreeFiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
