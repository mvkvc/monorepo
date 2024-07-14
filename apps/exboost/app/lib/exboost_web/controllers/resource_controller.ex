defmodule ExboostWeb.ResourceController do
  use ExboostWeb, :controller
  # alias Exboost.S3
  # alias Exboost.Resources

  # def presigned(conn, %{"key" => key} = _params) do
  #   case S3.generate_presigned_url(key) do
  #     {:ok, presigned_url} ->
  #       conn
  #       |> put_status(:ok)
  #       |> json(%{url: presigned_url})

  #     {:error, error} ->
  #       conn
  #       |> put_status(:bad_request)
  #       |> json(%{message: error})
  #   end
  # end

  # def create(conn, %{"key" => key} = _params) do
  #   user = conn.assigns[:current_user]
  #   url_bucket = Application.fetch_env!(:exboost, :url_bucket)
  #   url = url_bucket <> "/" <> key

  #   case Resources.create_resource(%{key: key, url: url, user_id: user.id}) do
  #     {:ok, resource} ->
  #       conn
  #       |> put_status(:created)
  #       |> json(resource)

  #     {:error, error} ->
  #       conn
  #       |> put_status(:bad_request)
  #       |> json(%{message: error})
  #   end
  # end

  # def delete(conn, %{"key" => key}) do
  #   user = conn.assigns[:current_user]

  #   with {:ok, resource} <- Resources.get_resource_by_user_and_key(key, user.id),
  #        {:ok, _} <- Resources.delete_resource(resource) do
  #     conn
  #     |> put_status(:ok)
  #     |> json(%{message: "deleted"})
  #   else
  #     {:error, error} ->
  #       conn
  #       |> put_status(:bad_request)
  #       |> json(%{message: error})
  #   end
  # end
end
