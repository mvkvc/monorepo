defmodule Critique.ResourcesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Critique.Resources` context.
  """

  @doc """
  Generate a image.
  """
  def image_fixture(attrs \\ %{}) do
    {:ok, image} =
      attrs
      |> Enum.into(%{
        link: "some link"
      })
      |> Critique.Resources.create_image()

    image
  end
end
