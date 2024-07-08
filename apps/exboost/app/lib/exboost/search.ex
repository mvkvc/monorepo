defmodule Exboost.Search do
  alias Exboost.Search.Result
  alias Exboost.Search.Exa

  @callback search(query :: String.t(), options :: options()) ::
              {:ok, [Result.t()]} | {:error, String.t()}

  @type options() :: [
          {:engine, :exa},
          {:num_results, integer()}
        ]

  @engines [
    exa: Exa
  ]

  def lookup(engine) do
    Keyword.get(@engines, engine)
  end

  def search(query, opts \\ []) do
    opts = Keyword.put_new(opts, :engine, :exa)
    opts = Keyword.put_new(opts, :num_results, 10)

    lookup(opts[:engine]).search(query, opts)
  end
end
