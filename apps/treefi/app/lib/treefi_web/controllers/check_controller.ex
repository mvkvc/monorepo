defmodule TreeFiWeb.CheckController do
  use TreeFiWeb, :controller

  def check(conn, _params) do
    json(conn, %{health: "check"})
  end
end
