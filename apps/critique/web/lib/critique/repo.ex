defmodule Critique.Repo do
  use Ecto.Repo,
    otp_app: :critique,
    adapter: Ecto.Adapters.Postgres
end
