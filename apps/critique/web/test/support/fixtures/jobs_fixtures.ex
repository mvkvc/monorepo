defmodule Critique.JobsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Critique.Jobs` context.
  """

  @doc """
  Generate a job.
  """
  def job_fixture(attrs \\ %{}) do
    {:ok, job} =
      attrs
      |> Enum.into(%{
        status: "some status"
      })
      |> Critique.Jobs.create_job()

    job
  end
end
