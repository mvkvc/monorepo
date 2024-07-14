defmodule Exboost.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :summary, :string
      add :hidden, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:chats, [:user_id])
  end
end
