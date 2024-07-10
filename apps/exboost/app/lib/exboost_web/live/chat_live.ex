defmodule ExboostWeb.ChatLive do
  use ExboostWeb, :live_view
  require Logger
  alias Phoenix.PubSub
  alias Exboost.Accounts
  alias Exboost.Accounts.User
  alias Exboost.Chats
  alias Exboost.Chats.Message
  alias Exboost.LLM
  alias Exboost.Search

  @sources_n 5
  @sources_length 300
  @summary_length 20

  def render(assigns) do
    ~H"""
    <div class="flex flex-row h-[calc(100vh-50px)] bg-gray-100">
      <div class="w-1/4 min-w-[25%] max-w-xs bg-base-200 p-2 flex flex-col overflow-hidden">
        <button class="btn btn-primary" phx-click="new_chat">New Chat</button>
        <div class="flex-grow overflow-y-auto">
          <ul class="menu w-full rounded-box">
            <%= for chat <- @chats do %>
              <li class="relative">
                <div class={"flex justify-between items-center w-full rounded-lg #{if @chat && @chat.id == chat.id, do: "bg-gray-600 bg-opacity-20", else: ""}"}>
                  <button
                    class="flex-grow text-left truncate py-1"
                    phx-click="change_chat"
                    phx-value-chat_id={chat.id}
                  >
                    <span class="block truncate">
                      <%= truncate_summary(chat.summary, @summary_length) %>
                    </span>
                  </button>
                  <button
                    class="flex-shrink-0 btn btn-ghost btn-xs mr-2"
                    phx-click="hide_chat"
                    phx-value-chat_id={chat.id}
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      class="inline-block w-4 h-4 stroke-current"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M6 18L18 6M6 6l12 12"
                      >
                      </path>
                    </svg>
                  </button>
                </div>
              </li>
            <% end %>
          </ul>
        </div>
      </div>

      <div class="flex-grow flex flex-col overflow-hidden">
        <div
          id="messages-container"
          class="flex-grow overflow-y-auto p-4 space-y-4"
          phx-hook="ScrollToBottom"
        >
          <%= for message <- @messages do %>
            <div class="chat chat-start">
              <div class={"chat-bubble cursor-pointer #{if @message && @message.id == message.id, do: "bg-secondary text-secondary-content", else: ""}"}>
                <button
                  class="w-full text-left"
                  phx-click="change_message"
                  phx-value-message_id={message.id}
                >
                  <%= message.content %>
                </button>
              </div>
            </div>
            <div class="chat chat-end">
              <div class="chat-bubble bg-primary text-primary-content">
                <%= if message.response do %>
                  <%= message.response %>
                <% else %>
                  <span class="loading loading-dots loading-sm"></span>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>

        <div class="p-4 bg-base-200">
          <.form
            id="user-input-form"
            for={@form}
            phx-submit="new_message"
            class="flex items-end space-x-2"
            phx-hook="Form"
          >
            <div class="flex-grow relative">
              <.input
                id="user-input"
                phx-hook="ResetInput"
                type="textarea"
                field={@form[:content]}
                class="w-full textarea textarea-bordered min-h-[60px] pr-[4.5rem]"
                placeholder="Type your message here..."
                rows="1"
              />
              <button type="submit" class="btn btn-primary absolute bottom-2 right-2">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                  class="w-5 h-5"
                >
                  <path d="M3.478 2.405a.75.75 0 00-.926.94l2.432 7.905H13.5a.75.75 0 010 1.5H4.984l-2.432 7.905a.75.75 0 00.926.94 60.519 60.519 0 0018.445-8.986.75.75 0 000-1.218A60.517 60.517 0 003.478 2.405z" />
                </svg>
              </button>
            </div>
          </.form>
        </div>
      </div>

      <%= if @message && @message.search_results && length(@message.search_results) > 0 do %>
        <div class="w-1/4 min-w-[25%] max-w-xs bg-base-200 p-4 flex flex-col overflow-hidden">
          <h2 class="text-xl font-semibold mb-4 text-center">Sources</h2>
          <div class="flex-grow overflow-y-auto overflow-x-hidden">
            <%= for source <- @message.search_results do %>
              <div class="card bg-base-100 shadow-sm mb-4">
                <div class="card-body p-4">
                  <h3 class="card-title text-sm truncate">
                    <a href={Map.get(source, "url")} target="_blank" class="link link-primary">
                      <%= Map.get(source, "title") %>
                    </a>
                  </h3>
                  <p class="text-xs">
                    <%= Map.get(source, "content")
                    |> String.slice(0..@sources_length) %>
                  </p>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp truncate_summary(summary, max_length) do
    if String.length(summary) > max_length do
      String.slice(summary, 0, max_length) <> "..."
    else
      summary
    end
  end

  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)
    socket = check_llm_settings(socket)

    chats =
      socket.assigns.current_user.id
      |> Chats.list_chats_by_user_visible()
      |> Enum.reverse()

    {:ok,
     socket
     |> assign(summary_length: @summary_length)
     |> assign(sources_length: @sources_length)
     |> assign(chats: chats)
     |> assign(messages: [])
     |> assign(chat: nil)
     |> assign(message: nil)
     |> push_event("focus-input", %{})
     |> socket_reset_form(), layout: false}
  end

  def handle_params(%{"chat-id" => chat_id}, _uri, socket) do
    chat = Chats.get_chat(chat_id)

    if chat && chat.visible do
      change_subscription(socket, chat_id)

      messages = Chats.list_messages_by_chat(chat_id)

      {:noreply,
       socket
       |> assign(messages: messages)
       |> assign(chat: chat)
       |> assign(
         message:
           List.last(messages)
           |> push_event("scroll-to-bottom", %{})
       )}
    else
      {:noreply, socket_reset(socket)}
    end
  end

  def handle_params(%{}, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("new_chat", _, socket) do
    trigger_summarize(socket.assigns.chat, socket.assigns.messages)

    {:noreply,
     socket
     |> push_event("scroll-to-bottom", %{})
     |> push_event("focus-input", %{})
     |> socket_reset()}
  end

  def handle_event("new_message", %{"message" => %{"content" => content}}, socket) do
    {chat, socket} = get_or_create_chat(socket, content)
    message_attrs = %{user_id: socket.assigns.current_user.id, chat_id: chat.id, content: content}
    {:ok, message} = Chats.create_message(message_attrs)
    send(self(), {:generate, chat.id, message.id, content, socket.assigns.messages})

    {:noreply,
     socket
     |> assign(messages: socket.assigns.messages ++ [message])
     |> assign(message: message)
     |> socket_reset_form()
     |> push_event("scroll-to-bottom", %{})}
  end

  def handle_event("hide_chat", %{"chat_id" => chat_id}, socket) do
    chat = Chats.get_chat!(chat_id)
    Chats.update_chat(chat, %{hidden: true})

    socket =
      if socket.assigns.chat && socket.assigns.chat.id == chat.id do
        socket_reset(socket)
      else
        updated_chats = Enum.reject(socket.assigns.chats, &(&1.id == chat.id))
        assign(socket, chats: updated_chats)
      end

    {:noreply, socket}
  end

  def handle_event("change_chat", %{"chat_id" => chat_id}, socket) do
    trigger_summarize(socket.assigns.chat, socket.assigns.messages)

    change_subscription(socket, chat_id)

    chat = Chats.get_chat!(chat_id)
    messages = Chats.list_messages_by_chat(chat_id)
    message = List.last(messages)

    {:noreply,
     socket
     |> assign(chat: chat)
     |> assign(messages: messages)
     |> assign(message: message)
     |> push_event("focus-input", %{})
     |> push_event("scroll-to-bottom", %{})}
  end

  def handle_event("change_message", %{"message_id" => message_id}, socket) do
    message = Chats.get_message!(message_id)

    {:noreply,
     socket
     |> assign(message: message)}
  end

  def handle_event("submit", _, socket) do
    {:noreply, socket}
  end

  def handle_info({:generate, chat_id, message_id, query, messages}, socket) do
    Task.Supervisor.start_child(Exboost.TaskSupervisor, fn ->
      message = Chats.get_message!(message_id)
      formatted_messages = build_messages(messages)

      rewriter_prompt = """
      Write a search query based on the previous messages to best answer the following query. Be extremely concise and specific and only return the search query and nothing else.

      Query: #{query}
      """

      {message, search_context} =
        with false <- is_nil(socket.assigns.current_user.search_api_key),
             {:ok, search_query} <-
               LLM.chat(
                 rewriter_prompt,
                 messages: formatted_messages,
                 model: socket.assigns.current_user.llm_model,
                 base_url: socket.assigns.current_user.llm_base_url,
                 api_key: socket.assigns.current_user.llm_api_key
               ),
             {:ok, search_results} <-
               Search.search(search_query,
                 engine: socket.assigns.current_user.search_engine,
                 api_key: socket.assigns.current_user.search_api_key,
                 num_results: @sources_n
               ),
             {:ok, message} <-
               Chats.update_message(message, %{
                 search_query: search_query,
                 search_results: search_results
               }) do
          PubSub.broadcast(
            Exboost.PubSub,
            "chat:#{chat_id}",
            {:message, message.id, message}
          )

          {message, Enum.map(search_results, & &1["content"])}
        else
          _ ->
            {message, []}
        end

      llm_stream_handler = fn chunk ->
        PubSub.broadcast(
          Exboost.PubSub,
          "chat:#{chat_id}",
          {:response_chunk, message_id, chunk}
        )
      end

      response =
        case LLM.chat(query,
               messages: formatted_messages,
               handler: llm_stream_handler,
               search_results: search_context,
               model: socket.assigns.current_user.llm_model,
               base_url: socket.assigns.current_user.llm_base_url,
               api_key: socket.assigns.current_user.llm_api_key
             ) do
          {:ok, response} ->
            response

          {:error, error} ->
            "Failed to generate response with error: #{inspect(error)}"
        end

      {:ok, message} =
        Chats.update_message(message, %{
          search_engine: socket.assigns.current_user.search_engine,
          llm_model: socket.assigns.current_user.llm_model,
          llm_prompt: query,
          response: response
        })

      PubSub.broadcast(Exboost.PubSub, "chat:#{chat_id}", {:message, message_id, message})
    end)

    {:noreply, socket}
  end

  def handle_info({:summarize, chat, messages} = message, socket) do
    IO.inspect(message, label: "SUMMARIZE")

    formatted_messages = build_messages(messages)

    summary_prompt = """
    Write an extremely short and concise summary label of this conversation. Your label should always be at most 5 words long even shorter if possible. Only respond with the summary label and nothing else.

    Label:
    """

    with {:ok, summary} <-
           LLM.chat(
             summary_prompt,
             messages: formatted_messages,
             model: socket.assigns.current_user.llm_model,
             base_url: socket.assigns.current_user.llm_base_url,
             api_key: socket.assigns.current_user.llm_api_key
           ),
         {:ok, chat} <- Chats.update_chat(chat, %{summary: summary, summarized: true}) do
      {:noreply, find_update(socket, :chats, chat.id, fn _ -> chat end)}
    else
      _ ->
        {:noreply, socket}
    end
  end

  def handle_info({:response_chunk, message_id, chunk}, socket) do
    socket =
      find_update(socket, :messages, message_id, fn message ->
        Map.update(message, :response, chunk, fn
          nil -> chunk
          response -> response <> chunk
        end)
      end)

    {:noreply, push_event(socket, "scroll-to-bottom", %{})}
  end

  def handle_info({:message, message_id, message}, socket) do
    {:noreply,
     socket
     |> assign(message: message)
     |> find_update(:messages, message_id, fn _ -> message end)}
  end

  defp trigger_summarize(nil, _messages), do: nil

  defp trigger_summarize(chat, messages) do
    if !chat.summarized && length(messages) > 1 do
      send(self(), {:summarize, chat, messages})
    end
  end

  defp build_message(content, role) when is_binary(content), do: %{role: role, content: content}
  defp build_message(_content, _role), do: nil

  defp build_messages(messages) do
    Enum.flat_map(messages, fn message ->
      [
        build_message(message.content, "user"),
        build_message(message.response, "assistant")
      ]
      |> Enum.reject(&(&1 == nil))
    end)
  end

  defp get_or_create_chat(socket, summary) do
    case socket.assigns.chat do
      nil ->
        chat_attrs = %{
          user_id: socket.assigns.current_user.id,
          summary: summary
        }

        {:ok, chat} = Chats.create_chat(chat_attrs)
        change_subscription(socket, chat.id)

        {chat,
         socket
         |> assign(chat: chat)
         |> assign(chats: [chat | socket.assigns.chats])}

      chat ->
        {chat, socket}
    end
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
    |> assign(chat: nil)
    |> assign(message: nil)
    |> socket_reset_form()
  end

  defp socket_reset_form(socket) do
    socket
    |> assign(form: to_form(Message.changeset(%Message{}, %{})))
    |> push_event("reset-input", %{})
  end

  defp check_llm_settings(socket) do
    current_user = socket.assigns.current_user

    case User.llm_changeset(current_user, %{}) do
      %Ecto.Changeset{valid?: true} ->
        socket

      %Ecto.Changeset{valid?: false} ->
        socket
        |> put_flash(:error, "Please check LLM settings")
        |> redirect(to: ~p"/users/settings")
    end
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

  defp change_subscription(socket, chat_id) do
    if !is_nil(socket.assigns.chat) and socket.assigns.chat.id != chat_id do
      PubSub.unsubscribe(Exboost.PubSub, "chat:#{socket.assigns.chat.id}")
    end

    PubSub.subscribe(Exboost.PubSub, "chat:#{chat_id}")
  end

  defp find_update(socket, collection_name, id, update_fn) do
    collection = socket.assigns[collection_name]

    case Enum.find_index(collection, &(&1.id == id)) do
      nil ->
        socket

      index ->
        assign(socket, collection_name, List.update_at(collection, index, update_fn))
    end
  end
end
