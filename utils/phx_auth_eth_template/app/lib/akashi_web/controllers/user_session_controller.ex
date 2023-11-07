defmodule AkashiWeb.UserSessionController do
  use AkashiWeb, :controller

  alias Akashi.Accounts
  alias AkashiWeb.UserAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully!")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  defp create(conn, user_params, info) do
    IO.inspect(user_params, label: "user_params in user_session_controller create")
    %{"public_address" => public_address, "signature" => signature} = user_params

    if user = Accounts.verify_message_signature(public_address, signature) do
      conn
      |> put_flash(:success, info)
      |> UserAuth.log_in_user(user, user_params)
    else
      conn
      |> put_flash(:error, "Invalid signature.")
      |> redirect(to: ~p"/")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:success, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
