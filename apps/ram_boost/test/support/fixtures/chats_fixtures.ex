defmodule RB.ChatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RB.Chats` context.
  """

  @doc """
  Generate a chat.
  """
  def chat_fixture(attrs \\ %{}) do
    {:ok, chat} =
      attrs
      |> Enum.into(%{
        summary: "some summary"
      })
      |> RB.Chats.create_chat()

    chat
  end

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> RB.Chats.create_message()

    message
  end
end
