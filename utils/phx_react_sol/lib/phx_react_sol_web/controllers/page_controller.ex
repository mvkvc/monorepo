defmodule PhxReactSolWeb.PageController do
  use PhxReactSolWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
