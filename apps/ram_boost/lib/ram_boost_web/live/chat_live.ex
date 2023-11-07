defmodule RBWeb.ChatLive do
  use RBWeb, :live_view
  alias RB.Chats
  alias RB.Chats.Chat
  alias RB.Chats.Message

  # Replace chats and messages with stream
  # Use changset and empty changeset for message and chat
  # Sources should be a list of chunks that are formatted to be able to be linked with preview

  def render(assigns) do
    ~H"""
    <h1>Chat</h1>
    <div class="flex flex-row">
      <div class="flex flex-col">
        <h2>History</h2>
        <%= for chat <- @chats do %>
          <div class="flex flex-row">
            <.link href={~p"/chat/#{chat.id}"}><%= chat.summary %></.link>
            <button phx-click="hide_chat" phx-value-id={chat.id}>Hide</button>
          </div>
        <% end %>
      </div>
      <div class="flex flex-col">
        <h2>Sources</h2>
      </div>
      <div class="flex flex-col">
        <h2>Messages</h2>
        <%= for message <- @messages do %>
          <div class="flex flex-row">
            <div class="flex flex-col">
              <p><%= message.content %></p>
            </div>
          </div>
        <% end %>
        <div class="flex flex-row">
          <.form for={@form} phx-submit="new_message">
            <.input type="textarea" field={@form[:content]} phx-hook="CtrlShiftSubmit"></.input>
            <button>Send</button>
          </.form>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)
    current_user = socket.assigns.current_user
    socket = socket_new(socket, current_user)

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    {:ok, chat} = Chats.get_chat!(id)
    socket = assign(socket, chat: chat)

    {:noreply, socket}
  end

  def handle_params(%{}, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("new_message", %{"message" => %{"content" => content}}, socket) do
    current_user = socket.assigns.current_user
    current_chat = socket.assigns.chat
    current_chat_messages = socket.assigns.messages

    socket =
      if !current_chat do
        chat_attrs = %{user_id: current_user.id, summary: content}
        {:ok, chat} = Chats.create_chat(chat_attrs)
        assign(socket, chat: chat)

        message_attrs = %{chat_id: chat.id, user_id: current_user.id, content: content}
        {:ok, message} = Chats.create_message(message_attrs)
        assign(socket, message: message)
        assign(socket, messages: current_chat_messages ++ [message])
      else
        message_attrs = %{chat_id: current_chat.id, user_id: current_user.id, content: content}
        {:ok, message} = Chats.create_message(message_attrs)
        assign(socket, message: message)
        assign(socket, messages: current_chat_messages ++ [message])
      end

    {:noreply, socket}
  end

  # def handle_event("hide_chat", %{} = params, socket) do
  #   IO.inspect(params)
  #   {:noreply, socket}
  # end

  def handle_event("hide_chat", %{"id" => id}, socket) do
    IO.inspect(id, label: "HIDE_CHAT")
    chat = Chats.get_chat!(id)
    Chats.update_chat(chat, %{visible: false})

    socket =
      assign(socket, chats: Chats.list_chats_by_user_visible(socket.assigns.current_user.id))

    {:noreply, socket}
  end

  defp socket_new(socket, current_user) do
    chats = Chats.list_chats_by_user_visible(current_user.id)
    changeset = Message.changeset(%Message{}, %{})

    socket
    |> assign(chats: chats)
    |> assign(messages: [])
    |> assign(sources: [])
    |> assign(chat: nil)
    |> assign(message: nil)
    |> assign(form: to_form(changeset))
  end

  defp socket_show(socket, current_user) do
    IO.inspect(socket)
    chats = Chats.list_chats_by_user_visible(current_user.id)
    chat = socket.assigns.chat
    messages = Chats.list_messages_by_chat(chat.id)
    message = messages |> List.last()

    # Setup sources

    socket
    |> assign(chats: chats)
    |> assign(messages: messages)
    |> assign(sources: [])
    |> assign(chat: chat)
    |> assign(message: message)
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
