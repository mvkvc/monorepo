defmodule CritiqueWeb.JobLiveTest do
  use CritiqueWeb.ConnCase

  import Phoenix.LiveViewTest
  import Critique.JobsFixtures

  @create_attrs %{status: "some status"}
  @update_attrs %{status: "some updated status"}
  @invalid_attrs %{status: nil}

  defp create_job(_) do
    job = job_fixture()
    %{job: job}
  end

  describe "Index" do
    setup [:create_job]

    test "lists all job", %{conn: conn, job: job} do
      {:ok, _index_live, html} = live(conn, ~p"/job")

      assert html =~ "Listing Job"
      assert html =~ job.status
    end

    test "saves new job", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/job")

      assert index_live |> element("a", "New Job") |> render_click() =~
               "New Job"

      assert_patch(index_live, ~p"/job/new")

      assert index_live
             |> form("#job-form", job: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#job-form", job: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/job")

      html = render(index_live)
      assert html =~ "Job created successfully"
      assert html =~ "some status"
    end

    test "updates job in listing", %{conn: conn, job: job} do
      {:ok, index_live, _html} = live(conn, ~p"/job")

      assert index_live |> element("#job-#{job.id} a", "Edit") |> render_click() =~
               "Edit Job"

      assert_patch(index_live, ~p"/job/#{job}/edit")

      assert index_live
             |> form("#job-form", job: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#job-form", job: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/job")

      html = render(index_live)
      assert html =~ "Job updated successfully"
      assert html =~ "some updated status"
    end

    test "deletes job in listing", %{conn: conn, job: job} do
      {:ok, index_live, _html} = live(conn, ~p"/job")

      assert index_live |> element("#job-#{job.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#job-#{job.id}")
    end
  end

  describe "Show" do
    setup [:create_job]

    test "displays job", %{conn: conn, job: job} do
      {:ok, _show_live, html} = live(conn, ~p"/job/#{job}")

      assert html =~ "Show Job"
      assert html =~ job.status
    end

    test "updates job within modal", %{conn: conn, job: job} do
      {:ok, show_live, _html} = live(conn, ~p"/job/#{job}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Job"

      assert_patch(show_live, ~p"/job/#{job}/show/edit")

      assert show_live
             |> form("#job-form", job: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#job-form", job: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/job/#{job}")

      html = render(show_live)
      assert html =~ "Job updated successfully"
      assert html =~ "some updated status"
    end
  end
end
