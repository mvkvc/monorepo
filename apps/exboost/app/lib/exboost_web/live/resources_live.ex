defmodule ExboostWeb.ResourcesLive do
  use ExboostWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Resources</h1>
    """
  end

  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign_current_user(session)}
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
