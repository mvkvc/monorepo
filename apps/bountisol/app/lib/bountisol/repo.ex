defmodule Bountisol.Repo do
  use Ecto.Repo,
    otp_app: :bountisol,
    adapter: Ecto.Adapters.Postgres
end
