defmodule OctoWeb.PageController do
  use OctoWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # render(conn, :home, layout: false)
    conn
    |> assign(:page_title, "Home")
    |> render(:home)
  end
end
