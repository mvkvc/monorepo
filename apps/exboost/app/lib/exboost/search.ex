defmodule Exboost.Search do
  alias Exboost.Search.Exa
  alias Exboost.Search.Serper

  @callback search(query :: String.t(), options :: options()) ::
              {:ok, map()} | {:error, String.t()}

  @type options() :: [
          {:engine, :exa},
          {:api_key, String.t()},
          {:num_results, integer()},
          {:content_max_length, integer()}
        ]

  @engines %{
    "exa" => Exa,
    "serper" => Serper
  }

  def lookup(engine) do
    Map.get(@engines, engine)
  end

  def search(query, opts \\ []) do
    opts = Keyword.put_new(opts, :engine, "exa")
    opts = Keyword.put_new(opts, :num_results, 5)
    opts = Keyword.put_new(opts, :content_max_length, 1000)
    opts = Keyword.put_new(opts, :api_key, System.get_env("SEARCH_API_KEY"))

    lookup(opts[:engine]).search(query, opts)
  end
end
