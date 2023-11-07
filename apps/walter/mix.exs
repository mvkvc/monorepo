defmodule Walter.MixProject do
  use Mix.Project

  def project do
    [
      app: :walter,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Walter.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:unchained, path: "../../libs/ex/unchained"},
      {:dotenv_parser, "~> 2.0"},
      {:nostrum, "~> 0.8.0"}
    ]
  end
end
