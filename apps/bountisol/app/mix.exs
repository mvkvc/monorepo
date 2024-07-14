defmodule Bountisol.MixProject do
  use Mix.Project

  @name "Bountisol"
  @description "Work with anyone from anywhere."
  @source_url "https://github.com/mvkvc/bountisol"
  @version "0.1.0"

  def project do
    [
      app: :bountisol,
      name: @name,
      description: @description,
      source_url: @source_url,
      version: @version,
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      docs: docs(),
      dialyzer: dialyzer(),
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      mod: {Bountisol.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  def cli do
    [
      default_env: :dev,
      preferred_envs: [testd: :test]
    ]
  end

  defp docs do
    [
      extras: [{:"README.md", [title: "Overview"]}],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}"
    ]
  end

  defp dialyzer do
    [
      plt_core_path: "plts",
      plt_file: {:no_warn, "plts/dialyzer.plt"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # {:portboy, git: "https://github.com/mvkvc/portboy.git"},
      {:portboy, path: "../../../os/portboy"},
      {:solana, git: "https://github.com/mvkvc/solana-elixir.git"},
      {:phoenix_live_react, git: "https://github.com/mvkvc/phoenix_live_react.git"},
      #
      {:instructor, "~> 0.0.4"},
      {:oban, "~> 2.16"},
      {:base58, "~> 0.1.1"},
      {:req, "~> 0.4.5"},
      {:random_color, "~> 0.1.0"},
      {:mnemonic_slugs, "~> 0.0.3"},
      {:bcrypt_elixir, "~> 3.0"},
      {:pgvector, "~> 0.2.0"},
      {:plug_cowboy, ">= 1.0.0"},
      #
      {:phoenix, "~> 1.7.10"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.1"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.2"},
      # {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      # {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, ">= 0.0.0"},
      #
      {:excellent_migrations, "~> 0.1", only: [:dev, :test], runtime: false},
      {:styler, "~> 0.10", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["cmd --cd assets yarn install --dev"],
      "assets.build": ["cmd --cd assets yarn build", "ports"],
      "assets.deploy": ["assets.build", "phx.digest"],
      testd: ["cmd sh/db_test.sh", "test", "cmd docker stop bountisol_test_db"],
      lint: ["format --check-formatted", "credo", "dialyzer"]
    ]
  end
end
