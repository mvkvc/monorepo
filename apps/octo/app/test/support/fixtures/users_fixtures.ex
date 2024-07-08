defmodule Octo.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Octo.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        icon: "some icon",
        name: "some name"
      })
      |> Octo.Users.create_user()

    user
  end
end
