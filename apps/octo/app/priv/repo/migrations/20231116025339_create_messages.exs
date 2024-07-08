defmodule Octo.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :sent, :naive_datetime
      add :type, :string
      add :chat_id, references(:chats, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:chat_id])
  end
end
