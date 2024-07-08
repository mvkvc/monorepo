defmodule Exboost.Repo.Migrations.CreateChunks do
  use Ecto.Migration

  def change do
    create table(:chunks) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :resource_id, references(:resources, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:chunks, [:resource_id])
  end
end
