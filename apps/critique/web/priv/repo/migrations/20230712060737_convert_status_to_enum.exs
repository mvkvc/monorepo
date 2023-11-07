defmodule Critique.Repo.Migrations.ConvertStatusToEnum do
  use Ecto.Migration

  # Might be uncessary as was string before
  def change do
    alter table(:job) do
      modify :status, :string
    end
  end
end
