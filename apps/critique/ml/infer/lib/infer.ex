defmodule Infer do
  use Plug.Router
  import Plug.Conn
  alias Infer.Serve
  alias Infer.Runpod
  require Logger

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  post "/" do
    Logger.debug(fn -> "conn.body_params: #{inspect(conn.body_params)}" end)

    case conn.body_params do
      %{"items" => items} ->
        Logger.debug("INCOMING ITEMS: #{inspect(items)}")
        params = Runpod.decode(items)
        result = Serve.predict(params)
        result_enc = Runpod.encode(result)
        Logger.debug("RESULT: #{result_enc}")
        body = Jason.encode!(result_enc)
        Logger.debug("BODY: #{body}")

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, body)

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{"error" => "Bad request"}))
    end
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, Jason.encode!(%{"error" => "Route not found"}))
  end
end
