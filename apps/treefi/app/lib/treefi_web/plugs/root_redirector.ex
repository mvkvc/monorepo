defmodule TreeFiWeb.Plugs.RootRedirector do
  def init(default), do: default

  def call(conn, _opts) do
    conn
    |> Phoenix.Controller.redirect(to: "/app")
    |> Plug.Conn.halt()
  end
end
