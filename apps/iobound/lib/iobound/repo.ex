defmodule IOBound.Repo do
  use Ecto.Repo,
    otp_app: :iobound,
    adapter: Ecto.Adapters.Postgres
end
