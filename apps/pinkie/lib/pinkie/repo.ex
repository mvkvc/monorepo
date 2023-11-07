defmodule Pinkie.Repo do
  use Ecto.Repo,
    otp_app: :pinkie,
    adapter: Ecto.Adapters.SQLite3,
    pool: Ecto.Adapters.SQL.Sandbox
end
