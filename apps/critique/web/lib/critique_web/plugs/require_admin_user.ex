defmodule CritiqueWeb.Plugs.RequireAdminUser do
  import Plug.Conn
  import Phoenix.Controller
  alias Critique.Accounts
  alias CritiqueWeb.UserAuth

  def init(default), do: default

  def call(conn, _default) do
    conn = UserAuth.fetch_current_user(conn, [])
    current_user = conn.assigns[:current_user]

    cond do
      current_user == nil ->
        conn
        |> put_flash(:error, "User must be logged in and an admin.")
        |> redirect(to: "/")
        |> halt()

      !Accounts.user_is_admin?(current_user) ->
        conn
        |> put_flash(:error, "User must be an admin.")
        |> redirect(to: "/")
        |> halt()

      true ->
        conn
    end
  end
end
