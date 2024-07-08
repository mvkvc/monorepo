defmodule ExboostWeb.ChatLive do
  use ExboostWeb, :live_view
  alias Exboost.Repo
  alias Exboost.Accounts
  alias Exboost.Chats
  alias Exboost.Chats.Message
  alias Exboost.Search

  def render(assigns) do
    ~H"""
    <h1>Chat</h1>
    <button phx-click="new_chat">New Chat</button>
    <div class="flex flex-row space-x-2">
      <div class="flex flex-col">
        <thead></thead>
        <tbody>
          <tr
            :for={chat <- @chats}
            class={"flex flex-row" <> if @chat && @chat.id == chat.id, do: " bg-gray-200", else: "bg-yellow-200"}
          >
            <td>
              <button phx-click="change_chat" phx-value-chat_id={chat.id}>
                <%= chat.summary %>
              </button>
            </td>
            <td>
              <button phx-click="hide_chat" phx-value-chat_id={chat.id}>
                Hide
              </button>
            </td>
          </tr>
        </tbody>
      </div>
      <div class="flex flex-col">
        <%= for message <- @messages do %>
            <button phx-click="change_message" phx-value-message_id={message.id}>
              <p><%= message.content %></p>
            </button>
            <%= if message.response do %>
              <p><%= message.response %></p>
            <% else %>
              <p>Loading...</p>
            <% end %>
          <% end %>
        <div>
          <.form for={@form} phx-submit="new_message">
            <.input type="textarea" field={@form[:content]}></.input>
            <button type="submit">Send</button>
          </.form>
        </div>
      </div>
      <div>
        <h2>Sources</h2>
        <div class="flex flex-col">
        <%= if @message && @message.search_results do %>
          <%= for source <- @message.search_results do %>
            <p><%= Map.get(source, "url") %></p>
          <% end %>
        <% else %>
          <p>Loading...</p>
        <% end %>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)
    current_user = socket.assigns.current_user
    chats = Chats.list_chats_by_user_visible(current_user.id) |> Enum.reverse()

    {:ok,
     socket
     |> assign(chats: chats)
     |> assign(messages: [])
     |> assign(sources: [])
     |> assign(chat: nil)
     |> assign(message: nil)
     |> assign(form: to_form(Message.changeset(%Message{}, %{})))}
  end

  def handle_params(%{"chat-id" => chat_id}, _uri, socket) do
    chat = Chats.get_chat!(chat_id)
    messages = Chats.list_messages_by_chat(chat_id)

    {:noreply,
     socket
     |> assign(messages: messages)
     |> assign(chat: chat)
     |> assign(message: List.last(messages))}
  end

  def handle_params(%{}, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("new_chat", _, socket) do
    {:noreply, socket_reset(socket)}
  end

  def handle_event("new_message", %{"message" => %{"content" => content}}, socket) do
    current_user = socket.assigns.current_user
    current_chat = socket.assigns.chat

    {chat, socket} =
      if !current_chat do
        chat_attrs = %{user_id: current_user.id, summary: content}
        {:ok, chat} = Chats.create_chat(chat_attrs)

        socket =
          socket
          |> assign(chat: chat)
          |> assign(chats: [chat | socket.assigns.chats])

        {chat, socket}
      else
        {current_chat, socket}
      end

    message_attrs = %{
      user_id: current_user.id,
      chat_id: chat.id,
      content: content,
      response: content
    }

    {:ok, message} = Chats.create_message(message_attrs)

    # send(self(), {:search, message_id, content})

    {:noreply,
     socket
     |> assign(messages: [socket.assigns.messages | message])
     |> assign(message: message)}
  end

  def handle_event("hide_chat", %{"chat_id" => chat_id}, socket) do
    current_chat = socket.assigns.chat
    chat = Chats.get_chat!(chat_id)
    Chats.update_chat(chat, %{hidden: true})

    updated_chats = socket.assigns.chats |> Enum.filter(fn c -> c.id != chat.id end)

    if current_chat && current_chat.id == chat.id do
      {:noreply, socket_reset(socket)}
    else
      {:noreply, assign(socket, chats: updated_chats)}
    end
  end

  def handle_event("change_chat", %{"chat_id" => chat_id}, socket) do
    current_chat = socket.assigns.chat
    chat = Chats.get_chat!(chat_id)
    messages = Chats.list_messages_by_chat(chat_id)
    message = List.last(messages)
    sources = message.search_results

    {:noreply,
     socket
     |> assign(chat: chat)
     |> assign(messages: messages)
     |> assign(message: message)
     |> assign(sources: sources)}
  end

  def handle_event("change_message", %{"message_id" => message_id}, socket) do
    message = Chats.get_message!(message_id)

    {:noreply,
     socket
     |> assign(message: message)
     |> assign(sources: message.search_results)}
  end

  def handle_info({:search, message_id, query}, socket) do
    message = Chats.get_message!(message_id)
    search_results = Search.search(query)
    Chats.update_message(message, %{search_results: search_results})
  end

  defp socket_reset(socket) do
    current_user = socket.assigns.current_user

    chats =
      current_user.id
      |> Chats.list_chats_by_user_visible()
      |> Enum.reverse()

    socket
    |> assign(chats: chats)
    |> assign(messages: [])
    |> assign(sources: [])
    |> assign(chat: nil)
    |> assign(message: nil)
    |> assign(form: to_form(Message.changeset(%Message{}, %{})))
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
