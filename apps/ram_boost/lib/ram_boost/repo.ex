defmodule RB.Repo do
  use Ecto.Repo,
    otp_app: :ram_boost,
    adapter: Ecto.Adapters.Postgres
end
