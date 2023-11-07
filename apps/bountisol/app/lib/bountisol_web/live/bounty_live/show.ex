defmodule BountisolWeb.BountyLive.Show do
  use BountisolWeb, :live_view

  alias Bountisol.Bounties
  alias Bountisol.Accounts

  @impl true
  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    bounty = Bounties.get_bounty!(id)
    submissions = Bounties.list_submissions_by_bounty(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:bounty, bounty)
     |> assign(:submissions, submissions)}
  end

  def handle_event("create_submission", %{"bounty_id" => bounty_id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/submissions/new/#{bounty_id}")}
  end

  def handle_event("deploy", _params, socket) do
    IO.puts("DEPLOY TRIGGERED")
    # bounty = socket.assigns.bounty
    {:noreply, push_event(socket, "bounty-create", %{})}
  end

  defp page_title(:show), do: "Show Bounty"
  defp page_title(:edit), do: "Edit Bounty"

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
