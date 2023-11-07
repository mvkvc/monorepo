defmodule SignUpWeb.SignUpController do
  use SignUpWeb, :controller
  alias SignUp.Accounts
  alias SignUp.Accounts.User

  def index(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "index.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome #{user.username}!")
        |> redirect(to: "/")

      {:error, changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end
end
