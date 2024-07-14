defmodule BankCrawl.MixProject do
  use Mix.Project

  def project do
    [
      app: :bank_crawl,
      elixir: "~> 1.17",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      releases: releases(),
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {BankCrawl.Application, []}
    ]
  end

  def releases do
    [
      bank_crawl: [
        steps: [:assemble, &Burrito.wrap/1],
        burrito: [
          targets: [
            linux: [os: get_os_type(), cpu: :x86_64]
          ]
        ]
      ]
    ]
  end

  defp deps do
    [
      {:csv, "~> 3.2"},
      {:crawly, "~> 0.15.0"},
      {:floki, "~> 0.34.0"},
      {:burrito, github: "burrito-elixir/burrito"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp aliases do
    [
      lint: [
        "credo --strict",
        "dialyzer"
      ]
    ]
  end

  def get_os_type do
    case :os.type() do
      {:unix, :darwin} -> :darwin
      {:unix, :linux} -> :linux
      {:win32, :nt} -> :windows
      _ -> :err
    end
  end
end
