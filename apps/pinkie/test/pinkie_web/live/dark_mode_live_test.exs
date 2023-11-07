# defmodule PinkieWeb.DarkModeLiveTest do
#   use PinkieWeb.ConnCase

#   import Phoenix.LiveViewTest
#   import Pinkie.InterfaceFixtures

#   @create_attrs %{}
#   @update_attrs %{}
#   @invalid_attrs %{}

#   defp create_dark_mode(_) do
#     dark_mode = dark_mode_fixture()
#     %{dark_mode: dark_mode}
#   end

#   describe "Index" do
#     setup [:create_dark_mode]

#     test "lists all dark_mode", %{conn: conn} do
#       {:ok, _index_live, html} = live(conn, Routes.dark_mode_index_path(conn, :index))

#       assert html =~ "Listing Dark mode"
#     end

#     test "saves new dark_mode", %{conn: conn} do
#       {:ok, index_live, _html} = live(conn, Routes.dark_mode_index_path(conn, :index))

#       assert index_live |> element("a", "New Dark mode") |> render_click() =~
#                "New Dark mode"

#       assert_patch(index_live, Routes.dark_mode_index_path(conn, :new))

#       assert index_live
#              |> form("#dark_mode-form", dark_mode: @invalid_attrs)
#              |> render_change() =~ "can&#39;t be blank"

#       {:ok, _, html} =
#         index_live
#         |> form("#dark_mode-form", dark_mode: @create_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.dark_mode_index_path(conn, :index))

#       assert html =~ "Dark mode created successfully"
#     end

#     test "updates dark_mode in listing", %{conn: conn, dark_mode: dark_mode} do
#       {:ok, index_live, _html} = live(conn, Routes.dark_mode_index_path(conn, :index))

#       assert index_live |> element("#dark_mode-#{dark_mode.id} a", "Edit") |> render_click() =~
#                "Edit Dark mode"

#       assert_patch(index_live, Routes.dark_mode_index_path(conn, :edit, dark_mode))

#       assert index_live
#              |> form("#dark_mode-form", dark_mode: @invalid_attrs)
#              |> render_change() =~ "can&#39;t be blank"

#       {:ok, _, html} =
#         index_live
#         |> form("#dark_mode-form", dark_mode: @update_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.dark_mode_index_path(conn, :index))

#       assert html =~ "Dark mode updated successfully"
#     end

#     test "deletes dark_mode in listing", %{conn: conn, dark_mode: dark_mode} do
#       {:ok, index_live, _html} = live(conn, Routes.dark_mode_index_path(conn, :index))

#       assert index_live |> element("#dark_mode-#{dark_mode.id} a", "Delete") |> render_click()
#       refute has_element?(index_live, "#dark_mode-#{dark_mode.id}")
#     end
#   end

#   describe "Show" do
#     setup [:create_dark_mode]

#     test "displays dark_mode", %{conn: conn, dark_mode: dark_mode} do
#       {:ok, _show_live, html} = live(conn, Routes.dark_mode_show_path(conn, :show, dark_mode))

#       assert html =~ "Show Dark mode"
#     end

#     test "updates dark_mode within modal", %{conn: conn, dark_mode: dark_mode} do
#       {:ok, show_live, _html} = live(conn, Routes.dark_mode_show_path(conn, :show, dark_mode))

#       assert show_live |> element("a", "Edit") |> render_click() =~
#                "Edit Dark mode"

#       assert_patch(show_live, Routes.dark_mode_show_path(conn, :edit, dark_mode))

#       assert show_live
#              |> form("#dark_mode-form", dark_mode: @invalid_attrs)
#              |> render_change() =~ "can&#39;t be blank"

#       {:ok, _, html} =
#         show_live
#         |> form("#dark_mode-form", dark_mode: @update_attrs)
#         |> render_submit()
#         |> follow_redirect(conn, Routes.dark_mode_show_path(conn, :show, dark_mode))

#       assert html =~ "Dark mode updated successfully"
#     end
#   end
# end
