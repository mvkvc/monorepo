defmodule Exboost.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Exboost.Accounts.User
  alias Exboost.Chats.Chat
  # alias Exboost.Chats.Result

  schema "messages" do
    field :content, :string
    field :response, :string
    field :llm_model, :string
    field :llm_prompt, :string
    field :search_engine, :string
    field :search_query, :string
    field :search_results, {:array, :map}

    belongs_to :user, User
    belongs_to :chat, Chat

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [
      :user_id,
      :chat_id,
      :content,
      :response,
      :llm_model,
      :llm_prompt,
      :search_engine,
      :search_query,
      :search_results
    ])
    |> validate_required([:user_id, :chat_id, :content])
  end
end
