defmodule Exboost.Repo.Migrations.AddChatSummarizedFlag do
  use Ecto.Migration

  def change do
    alter table(:chats) do
      add :summarized, :boolean, default: false
    end
  end
end
