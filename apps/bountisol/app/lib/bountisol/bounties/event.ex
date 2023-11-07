defmodule Bountisol.Bounties.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bountisol.Bounties.Bounty

  schema "events" do
    field :data, :map

    belongs_to :bounty, Bounty

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:data, :bounty_id])
    |> validate_required([])
  end
end
