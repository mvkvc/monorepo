defmodule Exboost.Repo.Migrations.AddChunkEmbeddings do
  use Ecto.Migration

  def change do
    alter table(:chunks) do
      add :embed, :vector, size: 1024
    end
  end
end
