defmodule SignUp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password, :string
    field :age, :integer
    field :birthdate, :date
    field :terms_and_conditions, :boolean, default: false
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :age, :birthdate, :terms_and_conditions])
    |> validate_required([:username, :password, :terms_and_conditions])
    |> validate_length(:username, min: 3, max: 12)
    |> validate_length(:password, min: 12, max: 50)
    |> validate_acceptance(:terms_and_conditions)
    |> validate_number(:age, greater_than: 0)
  end
end

# username (required) a 3-12 character string.
# password (required) a 12-50 character string.
# age an integer.
# birthdate a date.
# terms_and_conditions (required) a boolean which must be true.
