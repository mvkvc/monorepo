defmodule Critique.Repo.Migrations.CreateJob do
  use Ecto.Migration

  def change do
    create table(:job) do
      add :status, :string

      timestamps()
    end
  end
end
