defmodule Octo.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :summary, :string
      add :created, :naive_datetime
      add :last_updated, :naive_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
