defmodule Critique.Resources do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false
  alias Critique.Repo

  alias Critique.Resources.Image

  @doc """
  Returns the list of image.

  ## Examples

      iex> list_image()
      [%Image{}, ...]

  """
  def list_image do
    Repo.all(Image)
  end

  @doc """
  Gets a single image.

  Raises `Ecto.NoResultsError` if the Image does not exist.

  ## Examples

      iex> get_image!(123)
      %Image{}

      iex> get_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image!(id), do: Repo.get!(Image, id)

  @doc """
  Creates a image.

  ## Examples

      iex> create_image(%{field: value})
      {:ok, %Image{}}

      iex> create_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  # def create_image(attrs \\ %{}) do
  #   %Image{}
  #   |> Image.changeset(attrs)
  #   |> Repo.insert()
  # end

  alias Critique.Accounts.User
  alias Critique.Jobs.Job
  alias Ecto.Changeset

  def create_image(attrs \\ %{}) do
    with {:ok, %User{} = user} <- get_user(attrs.user_id),
         {:ok, %Job{} = job} <- get_job(attrs.job_id) do
      %Image{}
      |> Image.changeset(attrs)
      |> Changeset.put_assoc(:user, user)
      |> Changeset.put_assoc(:job, job)
      |> Repo.insert()
    end
  end

  defp get_user(id) do
    user = Repo.get(User, id)

    case user do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end

  defp get_job(id) do
    job = Repo.get(Job, id)

    case job do
      nil -> {:error, :job_not_found}
      job -> {:ok, job}
    end
  end

  @doc """
  Updates a image.

  ## Examples

      iex> update_image(image, %{field: new_value})
      {:ok, %Image{}}

      iex> update_image(image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_image(%Image{} = image, attrs) do
    image
    |> Image.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a image.

  ## Examples

      iex> delete_image(image)
      {:ok, %Image{}}

      iex> delete_image(image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_image(%Image{} = image) do
    Repo.delete(image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image changes.

  ## Examples

      iex> change_image(image)
      %Ecto.Changeset{data: %Image{}}

  """
  def change_image(%Image{} = image, attrs \\ %{}) do
    Image.changeset(image, attrs)
  end
end
