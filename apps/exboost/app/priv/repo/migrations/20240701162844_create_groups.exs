defmodule Exboost.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      timestamps(type: :utc_datetime)
    end
  end
end
