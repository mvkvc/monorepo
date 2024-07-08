defmodule Exboost.ChatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Exboost.Chat` context.
  """

  @doc """
  Generate a result.
  """
  def result_fixture(attrs \\ %{}) do
    {:ok, result} =
      attrs
      |> Enum.into(%{
        engine: "some engine",
        results: %{}
      })
      |> Exboost.Chat.create_result()

    result
  end
end
