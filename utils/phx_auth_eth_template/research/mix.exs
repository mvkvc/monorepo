defmodule Research.MixProject do
  use Mix.Project

  def project do
    [
      app: :research,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:bayex, path: "../libs/bayex"}
    ]
  end
end
