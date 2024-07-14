defmodule Lbdev.Build do
  alias Lbdev.Extract

  def build(config, path) do
    notebooks = Keyword.get(config, :notebooks)
    base = get_in(config, [:tags, :base])
    lib = get_in(config, [:tags, :lib])
    test = get_in(config, [:tags, :test])

    #   path
    #   |> Extract.extract()
    #   |> IO.inspect()
  end
end
