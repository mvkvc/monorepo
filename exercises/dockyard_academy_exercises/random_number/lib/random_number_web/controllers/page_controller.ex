defmodule RandomNumberWeb.PageController do
  use RandomNumberWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
