defmodule Exboost.Search.Exa do
  alias Exboost.Search.Result

  @behaviour Exboost.Search

  def search(query, opts \\ []) do
    headers = [
      {"accept", "application/json"},
      {"content-type", "application/json"},
      {"x-api-key", Application.fetch_env!(:exboost, :exa_api_key)}
    ]

    body = %{
      query: query,
      type: "magic",
      numResults: opts[:num_results],
      contents: %{
        text: true
      }
    }

    case Req.post(
           "https://api.exa.ai/search",
           headers: headers,
           body: Jason.encode!(body)
         ) do
      {:ok, %Req.Response{status: 200, body: %{"results" => results}}} ->
        Enum.reduce(results, [], fn
          %{"url" => url, "text" => text}, acc ->
            [%Result{url: url, content: text} | acc]

          result, acc ->
            acc
        end)

      {:ok, %Req.Response{status: status}} ->
        {:error, status}
    end
  end
end
