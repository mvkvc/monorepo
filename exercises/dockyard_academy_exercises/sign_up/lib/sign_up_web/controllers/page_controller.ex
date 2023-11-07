defmodule SignUpWeb.PageController do
  use SignUpWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
