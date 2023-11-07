defmodule Akashi.Repo.Migrations.AddUserEthFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :eth_address, :string, null: false
      add :eth_nonce, :string, null: false
      remove :email
      remove :hashed_password
      remove :confirmed_at
    end

    alter table(:users) do
      add :email, :string
    end

    create unique_index(:users, [:eth_address])
  end
end
