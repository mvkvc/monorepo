defmodule Octo.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Octo.Chats.Chat

  schema "messages" do
    field :type, :string
    field :sent, :naive_datetime
    field :content, :string

    belongs_to :chat, Chat

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :sent, :type])
    |> validate_required([:content, :sent, :type])
  end
end
