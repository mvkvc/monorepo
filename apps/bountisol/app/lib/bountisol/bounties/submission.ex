defmodule Bountisol.Bounties.Submission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bountisol.Accounts.User
  alias Bountisol.Bounties.Bounty

  schema "submissions" do
    field :content, :string

    belongs_to :user, User
    belongs_to :bounty, Bounty

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(submission, attrs) do
    submission
    |> cast(attrs, [:content, :user_id, :bounty_id])
    |> validate_required([:content, :user_id, :bounty_id])
    |> unique_constraint([:bounty_id, :user_id], message: "already submitted")
  end
end
