defmodule Octo.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset
  alias Octo.Chats.Message

  schema "chats" do
    field :summary, :string
    field :created, :naive_datetime
    field :last_updated, :naive_datetime

    has_many :messages, Message, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:summary, :last_updated])
    |> validate_required([:summary, :last_updated])
  end
end
