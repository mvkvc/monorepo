# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RB.Repo.insert!(%RB.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias RB.Accounts

user_attrs = %{
  email: "test@test.com",
  password: "testtesttest"
}

{:ok, _user} = Accounts.register_user(user_attrs)
