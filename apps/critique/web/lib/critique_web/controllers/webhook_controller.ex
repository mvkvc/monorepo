defmodule CritiqueWeb.WebhookController do
  use CritiqueWeb, :controller
  alias CritiqueWeb.Runpod
  alias Critique.Jobs
  alias Critique.Jobs.Job
  alias Critique.Resources.Image
  alias Critique.Repo

  # Research Repo transactions

  def hook(conn, %{"job_id" => job_id} = params) do
    IO.inspect(params, label: "PARAMS")
    IO.inspect(job_id, label: "JOB_ID")

    inputs = Runpod.decode(params["input"]["items"])
    outputs = params["output"]
    status = params["status"]
    IO.inspect({inputs, outputs}, label: "INPUTS, OUTPUTS")

    # Update DB entry for job status and images in job predictions
    # ...

    job = Jobs.get_job!(job_id) |> Repo.preload(:images)

    job_atom_status =
      case status do
        "COMPLETED" -> :completed
        _ -> :error
      end

    update_job_status(job, job_atom_status)
    update_images_status(job.images, outputs)

    Phoenix.PubSub.broadcast(
      Critique.PubSub,
      "jobs:user:#{job.user_id}",
      {:update, job}
    )

    Phoenix.PubSub.broadcast(
      Critique.PubSub,
      "jobs:job:#{job_id}",
      {:update, {outputs, job_atom_status |> Atom.to_string()}}
    )

    json(conn, %{status: 200, message: "OK"})
  end

  defp update_job_status(%Job{} = job, new_status) do
    job
    |> Job.changeset(%{status: new_status})
    |> Repo.update!()
  end

  defp update_images_status(images, outputs) do
    Enum.map(images, fn image ->
      output = Enum.find(outputs, fn x -> x["id"] == to_string(image.id) end)

      if output && Map.has_key?(output, "prediction") do
        update_prediction(image, output["prediction"])
      end
    end)
  end

  def update_prediction(%Image{} = image, new_prediction) do
    image
    |> Image.changeset(%{prediction: new_prediction})
    |> Repo.update!()
  end
end
