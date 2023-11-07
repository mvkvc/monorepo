defmodule Blog.Posts.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    field :published_on, :date
    field :post_id, :id

    belongs_to :users, Blog.Accounts.User
    belongs_to :posts, Blog.Posts.Post

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :published_on])
    |> validate_required([:content, :published_on])
  end
end
