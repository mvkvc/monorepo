defmodule Train.MixProject do
  use Mix.Project

  def project do
    [
      app: :train,
      version: "0.1.0",
      elixir: "~> 1.14.5",
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
      {:exla, "~> 0.5.1"},
      {:nx, "~> 0.5.1"},
      {:axon, "~> 0.5.1"},
      {:bumblebee, "~> 0.3.0"},
      {:explorer, "~> 0.5.0"},
      {:image, "~> 0.28.0"},
      # Dev
      {:dialyxir, "~> 1.3", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end
end
