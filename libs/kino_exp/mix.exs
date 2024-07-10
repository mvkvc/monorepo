defmodule KinoExp.MixProject do
  use Mix.Project

  def project do
    [
      app: :kino_exp,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {KinoExp.Application, []}
    ]
  end

  defp deps do
    [
      {:kino, "~> 0.9.4"}
    ]
  end
end
