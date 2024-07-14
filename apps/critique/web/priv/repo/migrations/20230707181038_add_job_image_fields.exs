defmodule Critique.Repo.Migrations.AddJobImageFields do
  use Ecto.Migration

  def change do
    alter table(:job) do
      add :user_id, references(:users, on_delete: :nothing), null: false
    end

    alter table(:image) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :job_id, references(:job, on_delete: :nothing), null: false
      add :prediction, :float
    end

    create index(:job, [:user_id])
    create index(:image, [:user_id, :job_id])
  end
end
