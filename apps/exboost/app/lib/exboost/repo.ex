defmodule Exboost.Repo do
  use Ecto.Repo,
    otp_app: :exboost,
    adapter: Ecto.Adapters.Postgres
end
