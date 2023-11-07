defmodule NavigationWeb.AboutController do
  use NavigationWeb, :controller

  def index(conn, params_) do
    html(conn, "<h1>About</h1>")
  end
end
