defmodule TreeFi.Repo do
  use Ecto.Repo,
    otp_app: :treefi,
    adapter: Ecto.Adapters.Postgres
end
