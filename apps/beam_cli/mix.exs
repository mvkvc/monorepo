defmodule CLI.MixProject do
  use Mix.Project

  def project do
    [
      app: :cli,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
    ]
  end

  def application do
    [
      mod: {CLI, []},
      extra_applications: [:logger]
    ]
  end

  def releases do
    [
      cli: [
        steps: [:assemble, &Burrito.wrap/1],
        burrito: [
          targets: [
            macos: [os: :darwin, cpu: :x86_64],
            linux: [os: :linux, cpu: :x86_64],
            windows: [os: :windows, cpu: :x86_64]
          ]
        ]
      ]
    ]
  end

  defp deps do
    [
      {:burrito, "~> 1.0"}
    ]
  end
end
