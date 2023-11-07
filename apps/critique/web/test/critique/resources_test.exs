defmodule Critique.ResourcesTest do
  use Critique.DataCase

  alias Critique.Resources

  describe "image" do
    alias Critique.Resources.Image

    import Critique.ResourcesFixtures

    @invalid_attrs %{link: nil}

    test "list_image/0 returns all image" do
      image = image_fixture()
      assert Resources.list_image() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Resources.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      valid_attrs = %{link: "some link"}

      assert {:ok, %Image{} = image} = Resources.create_image(valid_attrs)
      assert image.link == "some link"
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resources.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()
      update_attrs = %{link: "some updated link"}

      assert {:ok, %Image{} = image} = Resources.update_image(image, update_attrs)
      assert image.link == "some updated link"
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Resources.update_image(image, @invalid_attrs)
      assert image == Resources.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Resources.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Resources.change_image(image)
    end
  end
end
