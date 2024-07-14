defmodule PinkieWeb.DarkModeLive do
  use Phoenix.LiveView
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <button
    id="toggle-darkmode"
    phx-click={JS.push("toggle-darkmode") |> JS.dispatch("toggle-darkmode")}
    class="btn bg-slate-200 dark:bg-slate-700 hover:bg-slate-200 dark:hover:bg-slate-700
    text-black dark:text-white"
    >Theme</button>
    <%!-- <text><%= "Dark mode is #{if assigns.dark_mode, do: "on", else: "off"}" %></text> --%>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{dark_mode: false})}
  end

  def handle_event("toggle-darkmode", _params, socket) do
    {:noreply, assign(socket, %{dark_mode: !socket.assigns.dark_mode})}
  end
end
