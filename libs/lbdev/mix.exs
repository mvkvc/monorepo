defmodule Lbdev.MixProject do
  use Mix.Project

  @name "lbdev"
  @description "Use Livebooks to write, test, and document your Elixir code all in one place."
  @source_url "https://github.com/mvkvc/lbdev"
  @version "0.1.0"

  def project do
    [
      app: :lbdev,
      name: @name,
      description: @description,
      source_url: @source_url,
      version: @version,
      elixir: "~> 1.14.3",
      start_permanent: Mix.env() == :prod,
      docs: docs(),
      dialyzer: dialyzer(),
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
      # mod: {Lbdev.Application, []}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [{:"README.md", [title: "Outline"]}] ++ Path.wildcard("docs/*.md"),
      source_url: @source_url
    ]
  end

  defp dialyzer do
    [
      plt_core_path: "priv/plts",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  defp deps do
    [
      {:file_system, "~> 0.2"},
      {:earmark_parser, "~> 1.4"},
      {:dialyxir, "~> 1.2", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      docs: ["docs --formatter html"]
    ]
  end
end
