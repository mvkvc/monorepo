defmodule Bountisol.Repo.Migrations.ChangeUserLogin do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :hashed_password
      modify :email, :string, null: true
      add :address, :string, null: false
      add :nonce, :string, null: false
      add :domain, :string
    end

    create unique_index(:users, [:address])
  end
end
