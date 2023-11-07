defmodule TreeFi.Payments.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "account" do
    field :denomination, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(accounts, attrs) do
    accounts
    |> cast(attrs, [:denomination])
    |> validate_required([:denomination])
  end
end
