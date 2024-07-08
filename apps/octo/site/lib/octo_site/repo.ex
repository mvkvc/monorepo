defmodule OctoSite.Repo do
  use Ecto.Repo,
    otp_app: :octo_site,
    adapter: Ecto.Adapters.SQLite3
end
