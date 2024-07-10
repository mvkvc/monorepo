defmodule Exboost.Repo.Migrations.AddLlmSettingsUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :llm_model, :string
      add :llm_base_url, :string
      add :llm_api_key, :string
      add :search_engine, :string, default: "exa"
      add :search_api_key, :string
    end
  end
end
