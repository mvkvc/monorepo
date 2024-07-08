defmodule Octo.Repo do
  use Ecto.Repo,
    otp_app: :octo,
    adapter: Ecto.Adapters.SQLite3
end
