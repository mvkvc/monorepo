defmodule Exboost.Resources.Chunk do
  use Ecto.Schema
  import Ecto.Changeset
  alias Exboost.Resources.Resource

  schema "chunks" do
    field :embed, Pgvector.Ecto.Vector

    belongs_to :user, User
    belongs_to :resource, Resource

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chunk, attrs) do
    chunk
    |> cast(attrs, [:embed, :resource_id])
    |> validate_required([:embed, :resource_id])
  end
end
