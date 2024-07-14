defmodule TreeFi.Payments.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias TreeFi.Payments.Account

  schema "transactions" do
    field :denomination, :string
    field :amount, :integer

    belongs_to :account, Account

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transactions, attrs) do
    transactions
    |> cast(attrs, [:denomination, :amount])
    |> validate_required([:denomination, :amount])
  end
end
