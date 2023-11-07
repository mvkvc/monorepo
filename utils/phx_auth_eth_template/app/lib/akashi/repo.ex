defmodule Akashi.Repo do
  use Ecto.Repo,
    otp_app: :akashi,
    adapter: Ecto.Adapters.Postgres
end
