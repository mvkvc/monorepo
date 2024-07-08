defmodule Exboost.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Exboost.Accounts.User
  alias Exboost.Chats.Chat
  alias Exboost.Chats.Result

  schema "messages" do
    field :content, :string
    field :response, :string
    field :search_engine, :string, default: "exa"
    field :search_results, {:array, :map}, default: []

    belongs_to :user, User
    belongs_to :chat, Chat

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:user_id, :chat_id, :content, :search_engine, :search_results])
    |> validate_required([:chat_id, :content])
  end
end
