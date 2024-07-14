defmodule CritiqueWeb.RedirectController do
  use CritiqueWeb, :controller

  def uploads(conn, _params) do
    redirect(conn, to: ~p"/upload")
  end

  def jobs(conn, _params) do
    redirect(conn, to: ~p"/jobs")
  end

  # def jobs_id(conn, %{"id" => id}) do
  #   redirect(conn, to: ~p"/job/#{id}")
  # end
end
