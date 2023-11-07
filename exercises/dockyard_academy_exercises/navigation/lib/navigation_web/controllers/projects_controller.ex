defmodule NavigationWeb.ProjectsController do
  use NavigationWeb, :controller

  def index(conn, params_) do
    render(conn, "index.html")
  end
end
