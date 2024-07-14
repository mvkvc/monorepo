defmodule BountisolWeb.BountyLive.Index do
  use BountisolWeb, :live_view

  alias Bountisol.Bounties
  alias Bountisol.Bounties.Bounty
  alias Bountisol.Accounts

  @impl true
  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)
    {:ok, stream(socket, :bounties, Bounties.list_bounties())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Bounty")
    |> assign(:bounty, Bounties.get_bounty!(id))
  end

  defp apply_action(socket, :new, _params) do
    current_user = socket.assigns.current_user

    bounty = if current_user do
      %Bounty{user_id: current_user.id}
    else
      %Bounty{}
    end

    socket
    |> assign(:page_title, "New Bounty")
    |> assign(:bounty, bounty)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bounties")
    |> assign(:bounty, nil)
  end

  @impl true
  def handle_info({BountisolWeb.BountyLive.FormComponent, {:saved, bounty}}, socket) do
    {:noreply, stream_insert(socket, :bounties, bounty)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    bounty = Bounties.get_bounty!(id)
    {:ok, _} = Bounties.delete_bounty(bounty)

    {:noreply, stream_delete(socket, :bounties, bounty)}
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
