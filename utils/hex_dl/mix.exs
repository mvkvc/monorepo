defmodule HexDL.MixProject do
  use Mix.Project

  def project do
    [
      app: :hex_dl,
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
      {:req, "~> 0.4.5"},
      {:req_hex, "~> 0.1.0"}
    ]
  end
end
