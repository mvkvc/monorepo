defmodule Critique.JobsTest do
  use Critique.DataCase

  alias Critique.Jobs

  describe "job" do
    alias Critique.Jobs.Job

    import Critique.JobsFixtures

    @invalid_attrs %{status: nil}

    test "list_job/0 returns all job" do
      job = job_fixture()
      assert Jobs.list_job() == [job]
    end

    test "get_job!/1 returns the job with given id" do
      job = job_fixture()
      assert Jobs.get_job!(job.id) == job
    end

    test "create_job/1 with valid data creates a job" do
      valid_attrs = %{status: "some status"}

      assert {:ok, %Job{} = job} = Jobs.create_job(valid_attrs)
      assert job.status == "some status"
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create_job(@invalid_attrs)
    end

    test "update_job/2 with valid data updates the job" do
      job = job_fixture()
      update_attrs = %{status: "some updated status"}

      assert {:ok, %Job{} = job} = Jobs.update_job(job, update_attrs)
      assert job.status == "some updated status"
    end

    test "update_job/2 with invalid data returns error changeset" do
      job = job_fixture()
      assert {:error, %Ecto.Changeset{}} = Jobs.update_job(job, @invalid_attrs)
      assert job == Jobs.get_job!(job.id)
    end

    test "delete_job/1 deletes the job" do
      job = job_fixture()
      assert {:ok, %Job{}} = Jobs.delete_job(job)
      assert_raise Ecto.NoResultsError, fn -> Jobs.get_job!(job.id) end
    end

    test "change_job/1 returns a job changeset" do
      job = job_fixture()
      assert %Ecto.Changeset{} = Jobs.change_job(job)
    end
  end
end
