# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Exboost.Repo.insert!(%Exboost.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Exboost.Accounts

user_attrs = %{
  email: "test@test.com",
  password: "testtesttest"
}

test_user = Accounts.get_user_by_email(user_attrs.email)

if !test_user do
  {:ok, _user} = Accounts.register_user(user_attrs)
end
