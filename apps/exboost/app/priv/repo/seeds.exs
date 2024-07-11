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

register_attrs = %{
  email: "test@test.com",
  password: "testtesttest"
}

llm_attrs = %{
  llm_model: System.get_env("OPENAI_MODEL"),
  llm_base_url: System.get_env("OPENAI_BASE_URL"),
  llm_api_key: System.get_env("OPENAI_API_KEY"),
  search_engine: System.get_env("SEARCH_ENGINE", "exa"),
  search_api_key: System.get_env("SEARCH_API_KEY")
}

test_user = Accounts.get_user_by_email(register_attrs.email)

if !test_user do
  {:ok, user} = Accounts.register_user(register_attrs)
  {:ok, _user} = Accounts.update_user_llm(user, llm_attrs)
end
