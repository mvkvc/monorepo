defmodule Bountisol.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :data, :map
      add :bounty, references(:bounties, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:events, [:bounty])
  end
end
