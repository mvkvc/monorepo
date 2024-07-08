defmodule Exboost.ChatTest do
  use Exboost.DataCase

  alias Exboost.Chat

  describe "results" do
    alias Exboost.Chat.Result

    import Exboost.ChatFixtures

    @invalid_attrs %{engine: nil, results: nil}

    test "list_results/0 returns all results" do
      result = result_fixture()
      assert Chat.list_results() == [result]
    end

    test "get_result!/1 returns the result with given id" do
      result = result_fixture()
      assert Chat.get_result!(result.id) == result
    end

    test "create_result/1 with valid data creates a result" do
      valid_attrs = %{engine: "some engine", results: %{}}

      assert {:ok, %Result{} = result} = Chat.create_result(valid_attrs)
      assert result.engine == "some engine"
      assert result.results == %{}
    end

    test "create_result/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_result(@invalid_attrs)
    end

    test "update_result/2 with valid data updates the result" do
      result = result_fixture()
      update_attrs = %{engine: "some updated engine", results: %{}}

      assert {:ok, %Result{} = result} = Chat.update_result(result, update_attrs)
      assert result.engine == "some updated engine"
      assert result.results == %{}
    end

    test "update_result/2 with invalid data returns error changeset" do
      result = result_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_result(result, @invalid_attrs)
      assert result == Chat.get_result!(result.id)
    end

    test "delete_result/1 deletes the result" do
      result = result_fixture()
      assert {:ok, %Result{}} = Chat.delete_result(result)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_result!(result.id) end
    end

    test "change_result/1 returns a result changeset" do
      result = result_fixture()
      assert %Ecto.Changeset{} = Chat.change_result(result)
    end
  end
end
