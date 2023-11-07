defmodule SignUp.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SignUp.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        age: 42,
        birthdate: ~D[2023-03-14],
        terms_and_conditions: true,
        username: "some username"
      })
      |> SignUp.Accounts.create_user()

    user
  end
end
