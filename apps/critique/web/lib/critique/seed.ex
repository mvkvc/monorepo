defmodule Critique.Seed do
  alias Critique.Accounts

  def seed() do
    user_attrs = [
      %{
        email: "admin@critique.pics",
        password: System.get_env("ADMIN_PASSWORD"),
        admin: true,
        confirmed_at: NaiveDateTime.utc_now()
      },
      %{
        email: "demo@critique.pics",
        password: "demo1234demo",
        confirmed_at: NaiveDateTime.utc_now()
      }
    ]

    Enum.each(user_attrs, fn attrs ->
      Accounts.seed_user(attrs)
    end)
  end
end
