defmodule PinkieWeb.UserRegistrationController do
  use PinkieWeb, :controller

  alias Pinkie.Accounts
  alias Pinkie.Accounts.User
  alias PinkieWeb.UserAuth

  alias Pinkie.Repo

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        if Repo.all(User) |> length() == 1 do
          changeset = Accounts.change_user_registration(user)
          changeset = %{changeset | changes: %{is_admin: true}}
          {:ok, user} = Repo.update(changeset)
        end

        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
