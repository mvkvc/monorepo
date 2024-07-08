defmodule Exboost.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset
  alias Exboost.Accounts.User
  alias Exboost.Chats.Message

  schema "chats" do
    field :hidden, :boolean, default: false
    field :summary, :string

    belongs_to :user, User
    has_many :messages, Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:user_id, :hidden, :summary])
    |> validate_required([:hidden, :summary])
  end
end
