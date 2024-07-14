defmodule Bountisol.Bounties.Bounty do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bountisol.Accounts.User
  alias Bountisol.Bounties.Submission

  schema "bounties" do
    field :title, :string
    field :requirements, :string
    field :summary, :string
    field :tokens, :map
    field :gated, :boolean, default: false
    field :deadline, :utc_datetime
    field :account, :string
    field :status, :string, default: "not_deployed"

    belongs_to :user, User
    has_many :submissions, Submission

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bounty, attrs) do
    bounty
    |> cast(attrs, [:title, :summary, :requirements, :tokens, :gated, :deadline, :user_id])
    |> validate_required([:title, :summary, :requirements, :gated])
  end
end
