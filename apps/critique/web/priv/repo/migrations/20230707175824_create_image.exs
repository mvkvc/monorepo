defmodule Critique.Repo.Migrations.CreateImage do
  use Ecto.Migration

  def change do
    create table(:image) do
      add :link, :string

      timestamps()
    end
  end
end
