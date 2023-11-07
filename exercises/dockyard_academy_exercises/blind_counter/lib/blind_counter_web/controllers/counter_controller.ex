defmodule BlindCounterWeb.CounterController do
  use BlindCounterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
