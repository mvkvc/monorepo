defmodule CritiqueWeb.JobLive.Index do
  use CritiqueWeb, :live_view

  alias Critique.Jobs
  alias Critique.Jobs.Job
  alias Critique.Repo

  @limit 10

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    if connected?(socket),
      do: Phoenix.PubSub.subscribe(Critique.PubSub, "jobs:user:#{user_id}")

    {:ok,
    socket
    |> assign(:page, 1)
    |> stream(:job_collection, Jobs.list_jobs_for_user(user_id, limit: @limit) |> Repo.preload(:images))
  }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Job")
    |> assign(:job, Jobs.get_job!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Job")
    |> assign(:job, %Job{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Job")
    |> assign(:job, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    job = Jobs.get_job!(id)
    {:ok, _} = Jobs.delete_job(job)

    {:noreply, stream_delete(socket, :job_collection, job)}
  end

  @impl true
  def handle_event("load-more", _params, socket) do
    user_id = socket.assigns.current_user.id
    offset = socket.assigns.page * @limit
    jobs = Jobs.list_jobs_for_user(user_id, limit: @limit, offset: offset) |> Repo.preload(:images)

    {:noreply,
     socket
    |> assign(:page, socket.assigns.page + 1)
    |> stream_insert_many(:job_collection, jobs)
  }
  end

  @impl true
  def handle_info({CritiqueWeb.JobLive.FormComponent, {:saved, job}}, socket) do
    {:noreply, stream_insert(socket, :job_collection, job)}
  end

  @impl true
  def handle_info({:new, job}, socket) do
    {:noreply, stream_insert(socket, :job_collection, job, at: 0)}
  end

  @impl true
  def handle_info({:update, job}, socket) do
    IO.inspect("JOBS UPDATE IN INDEX")

    updated_socket =
      socket
      |> stream_delete(:job_collection, job)
      |> stream_insert(:job_collection, job, at: -1)

    {:noreply, updated_socket}
  end

  defp stream_insert_many(socket, ref, jobs) do
    Enum.reduce(jobs, socket, fn job, socket ->
      stream_insert(socket, ref, job)
    end)
  end
end
