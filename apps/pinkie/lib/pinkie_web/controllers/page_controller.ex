defmodule PinkieWeb.PageController do
  use PinkieWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
