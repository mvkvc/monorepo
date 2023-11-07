defmodule BountisolWeb.UserSessionController do
  use BountisolWeb, :controller

  alias Bountisol.Services

  # alias Bountisol.Accounts
  alias BountisolWeb.UserAuth

  # Create a new controller for validation of the signature
  # When validating, if correct then attach latest to the user
  # The user will then log in with their address and signature and if it matches the latest then they are logged in
  # Use Jason to pass around maps

  def create(conn, params) do
    create(conn, params, "Welcome!")
  end

  defp create(conn, %{"address" => address, "message" => message, "signature" => signature} = params, info) do
    user = Services.verify_signature(%{address: address, message: message, signature: signature})

    if user do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, params)
    else
      conn
      |> put_flash(:error, "Unable to verify signature.")
      |> redirect(to: ~p"/")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
