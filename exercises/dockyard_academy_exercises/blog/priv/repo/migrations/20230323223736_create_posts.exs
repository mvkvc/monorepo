defmodule Blog.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :content, :text
      add :published_on, :date
      add :visibile, :boolean, default: false, null: false

      timestamps()
    end
  end
end
