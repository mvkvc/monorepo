defmodule Octo.ChatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Octo.Chats` context.
  """

  @doc """
  Generate a chat.
  """
  def chat_fixture(attrs \\ %{}) do
    {:ok, chat} =
      attrs
      |> Enum.into(%{
        last_updated: ~N[2023-11-15 02:52:00],
        summary: "some summary"
      })
      |> Octo.Chats.create_chat()

    chat
  end

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content",
        sent: ~N[2023-11-15 02:53:00],
        type: "some type"
      })
      |> Octo.Chats.create_message()

    message
  end
end
