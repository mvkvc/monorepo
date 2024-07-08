defmodule OctoWeb.ChatLive do
  use OctoWeb, :live_view
  alias Octo.Chats
  alias Octo.Chats.Chat
  # alias Octo.Chats.Message

  @initial_history 10

  @impl true
  def render(assigns) do
    ~H"""
    <div class="h-[90vh] flex overflow-hidden bg-base-200">
      <%= if @sidebar do %>
        <div class="bg-gray-400 w-1/4 sm:w-1/3 h-full p-4">
          <h1 class="text-xl font-semibold">Chat History</h1>
        </div>
      <% end %>

      <div class={"flex flex-col flex-1 p-4" <>
          if @sidebar, do: " w-3/4 sm:w-2/3", else: " w-full"}>
        <button phx-click="toggle_sidebar" class="btn h-8 w-16">
          <.icon name={"hero-arrow-long-" <> if @sidebar, do: "left", else: "right"} class="h-16 w-16"/>
        </button>
        <div class="flex-1 overflow-y-auto p-4">
          <%= for chat <- @streams.chats do %>
            <div class="p-4 border-b border-base-300">
              <%= chat.content %>
            </div>
          <% end %>
        </div>

        <div class="p-4 bg-base-300">
          <form phx-submit="submit_prompt">
            <div class="form-control">
              <label class="label">
                <span class="label-text">Send a message:</span>
              </label>
              <input type="text" name="prompt" placeholder="Type here" class={if @state != :waiting, do: "disabled" <> "input input-bordered w-full"}>
            </div>
            <div class="form-control mt-2">
              <button type="submit" class={if @state != :waiting, do: "disabled" <> "btn btn-primary"}>Submit</button>
            </div>
          </form>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Octo.PubSub, "chats")
    end

    chats = Chats.list_chats_recent(@initial_history)

    {:ok,
     socket
     |> assign(:page_title, "Chat")
     |> assign(:state, :ready)
     |> assign(:prompt, "")
     |> assign(:sidebar, true)
     |> stream(:chats, chats)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    chat = Chats.get_chat!(id)
    {:ok, %Chat{}} = Chats.delete_chat(chat)

    {:noreply, stream_delete(socket, :chats, chat)}
  end

  @impl true
  def handle_event("toggle_sidebar", _params, socket) do
    new_sidebar_state = not socket.assigns[:sidebar]
    IO.inspect(new_sidebar_state, label: "SIDEBAR VAR")
    {:noreply, assign(socket, :sidebar, new_sidebar_state)}
  end

  @impl true
  def handle_info({:new, chat}, socket) do
    {:ok,
     socket
     |> stream_insert(:chats, chat, at: 0)}
  end

  @impl true
  def handle_info({:update, chat}, socket) do
    {:ok,
     socket
     |> stream_delete(:chats, chat)
     |> stream_insert(:chats, chat, at: -1)}
  end
end
