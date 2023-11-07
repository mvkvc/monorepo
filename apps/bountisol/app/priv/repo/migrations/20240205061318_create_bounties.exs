defmodule Bountisol.Repo.Migrations.CreateBounties do
  use Ecto.Migration

  def change do
    create table(:bounties) do
      add :title, :string
      add :summary, :string
      add :requirements, :text
      add :tokens, :map
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:bounties, [:user_id])
  end
end
