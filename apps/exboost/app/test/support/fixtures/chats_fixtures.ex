defmodule Exboost.ChatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Exboost.Chats` context.
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
      |> Exboost.Chats.create_chat()

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
      |> Exboost.Chats.create_message()

    message
  end
end
