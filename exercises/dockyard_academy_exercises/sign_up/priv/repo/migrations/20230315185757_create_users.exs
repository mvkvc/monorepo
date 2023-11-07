defmodule SignUp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :age, :integer
      add :birthdate, :date
      add :terms_and_conditions, :boolean, default: false, null: false

      timestamps()
    end
  end
end
