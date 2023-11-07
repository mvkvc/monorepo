defmodule Akashi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :eth_address, :string
    field :eth_nonce, :string
    field :email, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:eth_address, :eth_nonce, :email])
    |> validate_required([:eth_address, :eth_nonce])
    |> unique_constraint(:eth_address)
  end

  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, Akashi.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  # def confirm_changeset(user) do
  #   now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
  #   change(user, confirmed_at: now)
  # end
end
