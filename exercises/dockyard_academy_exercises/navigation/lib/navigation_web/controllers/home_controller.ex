defmodule NavigationWeb.HomeController do
  use NavigationWeb, :controller

  def index(conn, params_) do
    html(conn, "<h1>Home</h1>")
  end
end
