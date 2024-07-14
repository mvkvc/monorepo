defmodule Exboost.Repo.Migrations.AddMessageResponse do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :response, :text
      add :llm_model, :string
      add :llm_prompt, :text
      add :search_engine, :string
      add :search_query, :string
      add :search_results, {:array, :map}
    end
  end
end
