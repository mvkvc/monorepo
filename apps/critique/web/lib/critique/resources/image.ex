defmodule Critique.Resources.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "image" do
    field :link, :string
    field :prediction, :float

    belongs_to :user, Critique.Accounts.User
    belongs_to :job, Critique.Jobs.Job

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:link, :user_id, :job_id])
    |> validate_required([:link, :user_id, :job_id])
  end
end
