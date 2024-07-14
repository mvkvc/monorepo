defmodule CritiqueWeb.Runpod do
  require Logger

  @url_runpod "https://api.runpod.ai/v2/4i50jtk6moe6t0/runsync"

  def run(job_id, input) do
    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{System.get_env("RUNPOD_KEY")}"}
    ]

    url_webhook =
      case Application.get_env(:critique, :webhooks) do
        :prod ->
          "https://critique.pics/webhook"

        :local ->
          System.get_env("NGROK_URL") <> "/webhook"

        _ ->
          Logger.debug("INVALID URL WEBHOOK")
          ""
      end

    body = %{
      webhook: url_webhook <> "/#{job_id}",
      input: %{
        items: encode(input)
      }
    }

    IO.inspect(body, label: "SENDING WEBHOOK")

    result = Req.post(@url_runpod, body: Jason.encode!(body), headers: headers)

    case result do
      {:ok, response} ->
        if response.status == 200 do
          Logger.debug("Success calling #{@url_runpod}")
        else
          Logger.debug("Error calling #{@url_runpod} with status code #{response.status}")
        end

      {:error, _} ->
        Logger.debug("Error calling #{@url_runpod}")
    end
  end

  def encode(input) do
    input
    |> Enum.map(fn x ->
      Map.values(x) |> Enum.join(":")
    end)
    |> Enum.join(",")
  end

  def decode(input) do
    input
    |> String.split(",")
    |> Enum.map(fn x -> String.split(x, ":") end)
    |> Enum.map(fn x -> Enum.zip([:id, :prediction], x) end)
    |> Enum.map(fn x -> Enum.into(x, %{}) end)
  end
end
