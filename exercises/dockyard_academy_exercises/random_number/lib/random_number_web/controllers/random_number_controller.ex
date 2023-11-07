defmodule RandomNumberWeb.RandomNumberController do
  use RandomNumberWeb, :controller

  def index(conn, _params) do
    random = :rand.uniform(100)
    text(conn, "#{random}")
  end
end
