defmodule OctoFirmware.MixProject do
  use Mix.Project

  @app :octo_firmware
  @version "0.1.0"
  @all_targets [
    :rpi,
    :rpi4
  ]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.11",
      archives: [nerves_bootstrap: "~> 1.12"],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  def application do
    [
      mod: {OctoFirmware.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp deps do
    [
      {:octo, path: "../app", targets: @all_targets, env: Mix.env()},
      {:phoenix_client, "~> 0.11.1"},
      {:jason, "~> 1.4"},
      {:vintage_net_wizard, "~> 0.4", targets: @all_targets, override: true},

      {:scenic, github: "ScenicFramework/scenic", override: true},
      {:scenic_driver_local, "~> 0.11.0"},
      # {:scenic_driver_local, github: "ScenicFramework/scenic_driver_local", targets: :host, override: true},
      {:scenic_live_reload, ">= 0.0.0", targets: :host},
      {:scenic_driver_inky, github: "pappersverk/scenic_driver_inky", targets: @all_targets},
      {:inky, github: "pappersverk/inky", targets: @all_targets, override: true},
      
      # Dependencies for all targets
      {:nerves, "~> 1.10", runtime: false},
      {:shoehorn, "~> 0.9.1"},
      {:ring_logger, "~> 0.10.0"},
      {:toolshed, "~> 0.3.0"},

      # Allow Nerves.Runtime on host to support development, testing and CI.
      # See config/host.exs for usage.
      {:nerves_runtime, "~> 0.13.0"},

      # Dependencies for all targets except :host
      {:nerves_pack, "~> 0.7.0", targets: @all_targets},

      # Dependencies for specific targets
      # NOTE: It's generally low risk and recommended to follow minor version
      # bumps to Nerves systems. Since these include Linux kernel and Erlang
      # version updates, please review their release notes in case
      # changes to your application are needed.
      {:nerves_system_rpi4, "~> 1.24", runtime: false, targets: :rpi4}
      # {:nerves_system_rpi4, github: "mvkvc/nerves_system_rpi4", nerves: [compile: true]},
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end
end
