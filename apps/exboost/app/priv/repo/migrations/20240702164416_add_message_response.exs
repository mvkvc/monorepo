defmodule Exboost.Repo.Migrations.AddMessageResponse do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :response, :string
      add :search_engine, :string
      add :search_results, {:array, :map}, default: []
    end
  end
end
