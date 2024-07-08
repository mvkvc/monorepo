defmodule Exboost.Repo.Migrations.CreateResults do
  use Ecto.Migration

  def change do
    create table(:results) do
      add :engine, :string
      add :entries, :map

      add :message_id, references(:messages, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end
  end
end
