defmodule Bountisol.Repo.Migrations.CreateSubmissions do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :content, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :bounty_id, references(:bounties, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:submissions, [:user_id])
    create index(:submissions, [:bounty_id])
    create unique_index(:submissions, [:bounty_id, :user_id])
  end
end
