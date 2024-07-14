defmodule Bountisol.Repo.Migrations.AddOnchainBountyFields do
  use Ecto.Migration

  def change do
    alter table(:bounties) do
      add :account, :string
      add :status, :string, default: "not_deployed"
    end
  end
end
