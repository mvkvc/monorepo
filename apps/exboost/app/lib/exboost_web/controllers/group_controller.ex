defmodule ExboostWeb.GroupController do
  use ExboostWeb, :controller
  alias Exboost.S3
  alias Exboost.Resources

  def create(conn, %{"key" => key} = _params) do
  end

  def delete(conn, %{"key" => key}) do
  end
end
