defmodule BountisolWeb.SubmissionLive.Index do
  use BountisolWeb, :live_view

  alias Bountisol.Bounties
  alias Bountisol.Bounties.Submission
  alias Bountisol.Accounts

  @impl true
  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)
    current_user = socket.assigns.current_user
    {:ok, stream(socket, :submissions, Bounties.list_submissions_by_user(current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Submission")
    |> assign(:submission, Bounties.get_submission!(id))
  end

  defp apply_action(socket, :new, %{"bounty_id" => bounty_id}) do
    current_user = socket.assigns.current_user

    submission = %Submission{
      user_id: current_user.id,
      bounty_id: bounty_id
    }

    socket
    |> assign(:page_title, "New Submission")
    |> assign(:submission, submission)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Submissions")
    |> assign(:submission, nil)
  end

  @impl true
  def handle_info({BountisolWeb.SubmissionLive.FormComponent, {:saved, submission}}, socket) do
    {:noreply, stream_insert(socket, :submissions, submission)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    submission = Bounties.get_submission!(id)
    {:ok, _} = Bounties.delete_submission(submission)

    {:noreply, stream_delete(socket, :submissions, submission)}
  end

  defp assign_current_user(socket, session) do
    case session do
      %{"user_token" => user_token} ->
        assign_new(socket, :current_user, fn ->
          Accounts.get_user_by_session_token(user_token)
        end)

      %{} ->
        assign_new(socket, :current_user, fn -> nil end)
    end
  end
end
