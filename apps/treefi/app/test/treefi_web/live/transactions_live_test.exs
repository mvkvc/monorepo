defmodule TreeFiWeb.TransactionsLiveTest do
  use TreeFiWeb.ConnCase

  import Phoenix.LiveViewTest
  import TreeFi.PaymentsFixtures

  @create_attrs %{denomination: "some denomination", amount: 42}
  @update_attrs %{denomination: "some updated denomination", amount: 43}
  @invalid_attrs %{denomination: nil, amount: nil}

  defp create_transactions(_) do
    transactions = transactions_fixture()
    %{transactions: transactions}
  end

  describe "Index" do
    setup [:create_transactions]

    test "lists all transaction", %{conn: conn, transactions: transactions} do
      {:ok, _index_live, html} = live(conn, ~p"/transaction")

      assert html =~ "Listing Transaction"
      assert html =~ transactions.denomination
    end

    test "saves new transactions", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/transaction")

      assert index_live |> element("a", "New Transactions") |> render_click() =~
               "New Transactions"

      assert_patch(index_live, ~p"/transaction/new")

      assert index_live
             |> form("#transactions-form", transactions: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#transactions-form", transactions: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/transaction")

      html = render(index_live)
      assert html =~ "Transactions created successfully"
      assert html =~ "some denomination"
    end

    test "updates transactions in listing", %{conn: conn, transactions: transactions} do
      {:ok, index_live, _html} = live(conn, ~p"/transaction")

      assert index_live |> element("#transaction-#{transactions.id} a", "Edit") |> render_click() =~
               "Edit Transactions"

      assert_patch(index_live, ~p"/transaction/#{transactions}/edit")

      assert index_live
             |> form("#transactions-form", transactions: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#transactions-form", transactions: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/transaction")

      html = render(index_live)
      assert html =~ "Transactions updated successfully"
      assert html =~ "some updated denomination"
    end

    test "deletes transactions in listing", %{conn: conn, transactions: transactions} do
      {:ok, index_live, _html} = live(conn, ~p"/transaction")

      assert index_live
             |> element("#transaction-#{transactions.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#transaction-#{transactions.id}")
    end
  end

  describe "Show" do
    setup [:create_transactions]

    test "displays transactions", %{conn: conn, transactions: transactions} do
      {:ok, _show_live, html} = live(conn, ~p"/transaction/#{transactions}")

      assert html =~ "Show Transactions"
      assert html =~ transactions.denomination
    end

    test "updates transactions within modal", %{conn: conn, transactions: transactions} do
      {:ok, show_live, _html} = live(conn, ~p"/transaction/#{transactions}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Transactions"

      assert_patch(show_live, ~p"/transaction/#{transactions}/show/edit")

      assert show_live
             |> form("#transactions-form", transactions: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#transactions-form", transactions: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/transaction/#{transactions}")

      html = render(show_live)
      assert html =~ "Transactions updated successfully"
      assert html =~ "some updated denomination"
    end
  end
end
