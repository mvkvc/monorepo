defmodule PinkieWeb.HomeController do
  use PinkieWeb, :controller

  def index(conn, _params) do
    conn
    # |> put_flash(:info, "Hello")
    |> render("index.html")
  end
end
