defmodule BountisolWeb.BountyLiveTest do
  use BountisolWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bountisol.BountiesFixtures

  @create_attrs %{tokens: %{}, title: "some title", requirements: "some requirements", summary: "some summary"}
  @update_attrs %{tokens: %{}, title: "some updated title", requirements: "some updated requirements", summary: "some updated summary"}
  @invalid_attrs %{tokens: nil, title: nil, requirements: nil, summary: nil}

  defp create_bounty(_) do
    bounty = bounty_fixture()
    %{bounty: bounty}
  end

  describe "Index" do
    setup [:create_bounty]

    test "lists all bounties", %{conn: conn, bounty: bounty} do
      {:ok, _index_live, html} = live(conn, ~p"/bounties")

      assert html =~ "Listing Bounties"
      assert html =~ bounty.title
    end

    test "saves new bounty", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/bounties")

      assert index_live |> element("a", "New Bounty") |> render_click() =~
               "New Bounty"

      assert_patch(index_live, ~p"/bounties/new")

      assert index_live
             |> form("#bounty-form", bounty: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#bounty-form", bounty: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/bounties")

      html = render(index_live)
      assert html =~ "Bounty created successfully"
      assert html =~ "some title"
    end

    test "updates bounty in listing", %{conn: conn, bounty: bounty} do
      {:ok, index_live, _html} = live(conn, ~p"/bounties")

      assert index_live |> element("#bounties-#{bounty.id} a", "Edit") |> render_click() =~
               "Edit Bounty"

      assert_patch(index_live, ~p"/bounties/#{bounty}/edit")

      assert index_live
             |> form("#bounty-form", bounty: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#bounty-form", bounty: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/bounties")

      html = render(index_live)
      assert html =~ "Bounty updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes bounty in listing", %{conn: conn, bounty: bounty} do
      {:ok, index_live, _html} = live(conn, ~p"/bounties")

      assert index_live |> element("#bounties-#{bounty.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#bounties-#{bounty.id}")
    end
  end

  describe "Show" do
    setup [:create_bounty]

    test "displays bounty", %{conn: conn, bounty: bounty} do
      {:ok, _show_live, html} = live(conn, ~p"/bounties/#{bounty}")

      assert html =~ "Show Bounty"
      assert html =~ bounty.title
    end

    test "updates bounty within modal", %{conn: conn, bounty: bounty} do
      {:ok, show_live, _html} = live(conn, ~p"/bounties/#{bounty}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Bounty"

      assert_patch(show_live, ~p"/bounties/#{bounty}/show/edit")

      assert show_live
             |> form("#bounty-form", bounty: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#bounty-form", bounty: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/bounties/#{bounty}")

      html = render(show_live)
      assert html =~ "Bounty updated successfully"
      assert html =~ "some updated title"
    end
  end
end
