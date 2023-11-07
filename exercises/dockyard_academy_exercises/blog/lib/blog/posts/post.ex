defmodule Blog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :published_on, :date
    field :title, :string
    field :visibile, :boolean, default: false

    belongs_to :users, Blog.Accounts.User
    has_many :comments, Blog.Comments.Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :published_on, :visibile])
    |> validate_required([:title, :content, :published_on, :visibile])
  end
end
