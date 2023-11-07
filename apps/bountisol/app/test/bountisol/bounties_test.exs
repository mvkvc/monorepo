defmodule Bountisol.BountiesTest do
  use Bountisol.DataCase

  alias Bountisol.Bounties

  describe "bounties" do
    alias Bountisol.Bounties.Bounty

    import Bountisol.BountiesFixtures

    @invalid_attrs %{tokens: nil, title: nil, requirements: nil, summary: nil}

    test "list_bounties/0 returns all bounties" do
      bounty = bounty_fixture()
      assert Bounties.list_bounties() == [bounty]
    end

    test "get_bounty!/1 returns the bounty with given id" do
      bounty = bounty_fixture()
      assert Bounties.get_bounty!(bounty.id) == bounty
    end

    test "create_bounty/1 with valid data creates a bounty" do
      valid_attrs = %{tokens: %{}, title: "some title", requirements: "some requirements", summary: "some summary"}

      assert {:ok, %Bounty{} = bounty} = Bounties.create_bounty(valid_attrs)
      assert bounty.tokens == %{}
      assert bounty.title == "some title"
      assert bounty.requirements == "some requirements"
      assert bounty.summary == "some summary"
    end

    test "create_bounty/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bounties.create_bounty(@invalid_attrs)
    end

    test "update_bounty/2 with valid data updates the bounty" do
      bounty = bounty_fixture()
      update_attrs = %{tokens: %{}, title: "some updated title", requirements: "some updated requirements", summary: "some updated summary"}

      assert {:ok, %Bounty{} = bounty} = Bounties.update_bounty(bounty, update_attrs)
      assert bounty.tokens == %{}
      assert bounty.title == "some updated title"
      assert bounty.requirements == "some updated requirements"
      assert bounty.summary == "some updated summary"
    end

    test "update_bounty/2 with invalid data returns error changeset" do
      bounty = bounty_fixture()
      assert {:error, %Ecto.Changeset{}} = Bounties.update_bounty(bounty, @invalid_attrs)
      assert bounty == Bounties.get_bounty!(bounty.id)
    end

    test "delete_bounty/1 deletes the bounty" do
      bounty = bounty_fixture()
      assert {:ok, %Bounty{}} = Bounties.delete_bounty(bounty)
      assert_raise Ecto.NoResultsError, fn -> Bounties.get_bounty!(bounty.id) end
    end

    test "change_bounty/1 returns a bounty changeset" do
      bounty = bounty_fixture()
      assert %Ecto.Changeset{} = Bounties.change_bounty(bounty)
    end
  end

  describe "submissions" do
    alias Bountisol.Bounties.Submission

    import Bountisol.BountiesFixtures

    @invalid_attrs %{content: nil}

    test "list_submissions/0 returns all submissions" do
      submission = submission_fixture()
      assert Bounties.list_submissions() == [submission]
    end

    test "get_submission!/1 returns the submission with given id" do
      submission = submission_fixture()
      assert Bounties.get_submission!(submission.id) == submission
    end

    test "create_submission/1 with valid data creates a submission" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %Submission{} = submission} = Bounties.create_submission(valid_attrs)
      assert submission.content == "some content"
    end

    test "create_submission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bounties.create_submission(@invalid_attrs)
    end

    test "update_submission/2 with valid data updates the submission" do
      submission = submission_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Submission{} = submission} = Bounties.update_submission(submission, update_attrs)
      assert submission.content == "some updated content"
    end

    test "update_submission/2 with invalid data returns error changeset" do
      submission = submission_fixture()
      assert {:error, %Ecto.Changeset{}} = Bounties.update_submission(submission, @invalid_attrs)
      assert submission == Bounties.get_submission!(submission.id)
    end

    test "delete_submission/1 deletes the submission" do
      submission = submission_fixture()
      assert {:ok, %Submission{}} = Bounties.delete_submission(submission)
      assert_raise Ecto.NoResultsError, fn -> Bounties.get_submission!(submission.id) end
    end

    test "change_submission/1 returns a submission changeset" do
      submission = submission_fixture()
      assert %Ecto.Changeset{} = Bounties.change_submission(submission)
    end
  end

  describe "events" do
    alias Bountisol.Bounties.Event

    import Bountisol.BountiesFixtures

    @invalid_attrs %{data: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Bounties.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Bounties.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{data: %{}}

      assert {:ok, %Event{} = event} = Bounties.create_event(valid_attrs)
      assert event.data == %{}
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bounties.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{data: %{}}

      assert {:ok, %Event{} = event} = Bounties.update_event(event, update_attrs)
      assert event.data == %{}
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Bounties.update_event(event, @invalid_attrs)
      assert event == Bounties.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Bounties.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Bounties.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Bounties.change_event(event)
    end
  end
end
