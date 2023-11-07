defmodule Bountisol.Repo.Migrations.AddBountyGatedDeadline do
  use Ecto.Migration

  def change do
    alter table(:bounties) do
      add :gated, :boolean, default: false
      add :deadline, :utc_datetime
    end
  end
end
