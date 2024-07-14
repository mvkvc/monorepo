defmodule Exboost.Resources.Resource do
  use Ecto.Schema
  import Ecto.Changeset
  alias Exboost.Accounts.User
  alias Exboost.Resources.Group

  schema "resources" do
    field(:url, :string)
    field(:type, :string)

    belongs_to(:user, User)
    belongs_to(:group, Group)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:url, :type])
    |> validate_required([:url, :type])
  end
end
