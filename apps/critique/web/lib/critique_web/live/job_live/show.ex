defmodule CritiqueWeb.JobLive.Show do
  use CritiqueWeb, :live_view

  alias Critique.Repo
  alias Critique.Jobs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(Critique.PubSub, "jobs:job:#{id}")

    job = Jobs.get_job!(id) |> Repo.preload(:images)

    updated_socket =
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:job, job)

    {:noreply, updated_socket}
  end

  @impl true
  def handle_info({:update, {outputs, status}}, socket) do
    updated_images = update_images_with_outputs(outputs, socket.assigns.job.images)
    new_job = %{socket.assigns.job | status: status, images: updated_images}

    updated_socket =
      if status == "completed", do: put_flash(socket, :info, "Job completed."), else: socket

    {:noreply, assign(updated_socket, :job, new_job)}
  end

  defp update_images_with_outputs(outputs, images) do
    Enum.map(images, fn image ->
      output = outputs |> Enum.find(fn x -> String.to_integer(x["id"]) == image.id end)
      new_prediction = Map.get(output, "prediction", image.prediction)
      Map.put(image, :prediction, new_prediction)
    end)
  end

  defp page_title(:show), do: "Show Job"
  defp page_title(:edit), do: "Edit Job"
end
