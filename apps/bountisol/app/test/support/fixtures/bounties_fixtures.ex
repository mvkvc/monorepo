defmodule Bountisol.BountiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bountisol.Bounties` context.
  """

  @doc """
  Generate a bounty.
  """
  def bounty_fixture(attrs \\ %{}) do
    {:ok, bounty} =
      attrs
      |> Enum.into(%{
        requirements: "some requirements",
        summary: "some summary",
        title: "some title",
        tokens: %{}
      })
      |> Bountisol.Bounties.create_bounty()

    bounty
  end

  @doc """
  Generate a submission.
  """
  def submission_fixture(attrs \\ %{}) do
    {:ok, submission} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> Bountisol.Bounties.create_submission()

    submission
  end

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        data: %{}
      })
      |> Bountisol.Bounties.create_event()

    event
  end
end
