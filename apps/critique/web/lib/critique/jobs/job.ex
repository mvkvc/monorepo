defmodule Critique.Jobs.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "job" do
    field :status, Ecto.Enum, values: [:pending, :completed, :error], default: :pending

    belongs_to :user, Critique.Accounts.User
    has_many :images, Critique.Resources.Image

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:status, :user_id])
    |> validate_required([:status, :user_id])
  end
end
