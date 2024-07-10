defmodule PhxReactSol.Repo do
  use Ecto.Repo,
    otp_app: :phx_react_sol,
    adapter: Ecto.Adapters.SQLite3
end
