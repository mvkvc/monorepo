defmodule CritiqueWeb.UploadLive do
  use CritiqueWeb, :live_view
  alias Critique.Resources
  alias ExAws.S3
  alias CritiqueWeb.Runpod
  require ExImageInfo
  require Logger

  # @max_height 300
  @max_entries 5

  def render(assigns) do
 ~H"""
    <div class="">
      <.header>
        Upload
      </.header>

      <section phx-drop-target={@uploads.images.ref} class="mt-11 border-dashed border-2 border-gray-400 rounded relative bg-gray-100 text-center p-10">
        <form id="upload-form" phx-submit="save" phx-change="validate" class="">
          <div class="flex flex-col items-center space-y-4 h-full">
            <div class="space-x-2">
              <button
                type="reset"
                phx-click="clear"
                class="border border-gray-400 bg-gray-200 p-1 rounded-md shadow hover:shadow-md transition-shadow duration-150 ease-in-out w-20 text-center"
              >
                Clear
              </button>
              <button
                type="submit"
                class="border border-gray-400  bg-gray-200 p-1 rounded-md shadow hover:shadow-md transition-shadow duration-150 ease-in-out w-20 text-center"
              >
                Submit
              </button>
            </div>
            <.live_file_input upload={@uploads.images} class="flex items-center justify-center text-right" />
            <%= for err <- upload_errors(@uploads.images) do %>
              <p class="alert alert-danger"><%= error_to_string(err) %></p>
            <% end %>
            <div id="TEST" class="flex items-center min-h-full">
              <%= if length(@uploads.images.entries) < 1 do %>
                <span class="text-gray-600">Drag and drop to upload</span>
              <% end %>
              <%= if @uploading do %>
                <div class="">
                  <p class="text-xl text-gray-600">Initializing job, please wait...</p>
                </div>
              <% end %>
            </div>
          </div>
          <%= if !@uploading do %>
            <div class="file-list">
              <ul>
                <%= for entry <- @uploads.images.entries do %>
                  <li class="flex items-center sm:ml-4 md:ml-[15.5%] mb-4 space-x-4">
                    <div class="flex-none">
                      <figure>
                        <.live_img_preview entry={entry} style="width: 200px; max-height: 300px;" />
                      </figure>
                    </div>
                    <div class="flex flex-col">
                      <p><%= entry.client_name %></p>
                      <p><%= format_file_size(entry.client_size) %></p>
                      <%= if entry.progress > 0 && entry.progress < 100 do %>
                        <progress value={entry.progress} max="100"></progress>
                        <span>Upload in progress...</span>
                      <% end %>
                      <button
                        type="button"
                        phx-click="cancel-upload"
                        phx-value-ref={entry.ref}
                        aria-label="cancel"
                        class="text-left"
                      >
                        Cancel
                      </button>
                      <%= for err <- upload_errors(@uploads.images, entry) do %>
                        <p class="alert alert-danger"><%= error_to_string(err) %></p>
                      <% end %>
                    </div>
                  </li>
                <% end %>
              </ul>
            </div>
          <% end %>
        </form>
      </section>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:max_entries, @max_entries)
     |> assign(:uploading, false)
     |> assign(:images, [])
     |> allow_upload(:images,
       accept: [".png", ".jpg", ".jpeg"],
       max_entries: @max_entries
     )}
  end

  def handle_event("validate", _params, socket) do
    images = socket.assigns.uploads.images.entries

    updated_socket =
      cond do
        length(images) > @max_entries ->
          socket
          |> clear_uploads(:images)
          |> put_flash(:error, "You have selected too many images")

        true ->
          socket
      end

    {:noreply, updated_socket}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :images, ref)}
  end

  def handle_event("clear", _params, socket) do
    {:noreply, clear_uploads(socket, :images)}
  end

  def handle_event("save", _params, socket) do
    images = socket.assigns.uploads.images.entries

    updated_socket =
      cond do
        Enum.empty?(images) ->
          socket
          |> put_flash(:error, "You must upload at least one image before submitting.")

        true ->
          send(self(), :upload)

          socket
          |> assign(:uploading, true)
      end

    {:noreply, updated_socket}
  end

  def handle_info(:upload, socket) do
    # account_id = System.get_env("R2_ACCOUNT_ID")
    bucket_name = System.get_env("R2_BUCKET_NAME")
    # bucket_url = "https://#{account_id}.r2.cloudflarestorage.com/#{bucket_name}/"

    user_id = socket.assigns.current_user.id
    job_attrs = %{user_id: user_id}
    {:ok, job} = Critique.Jobs.create_job(job_attrs)

    uploaded_files =
      consume_uploaded_entries(socket, :images, fn %{path: path}, _entry ->
        {:ok, image_binary} = File.read(path)
        {mime, _, _, _} = ExImageInfo.info(image_binary)

        file_ext =
          case mime do
            "image/jpeg" -> ".jpg"
            "image/png" -> ".png"
            _ -> ""
          end

        image_uuid = Ecto.UUID.generate()
        unique_path = "#{user_id}/#{job.id}/#{image_uuid}#{file_ext}"

        image =
          S3.put_object(bucket_name, unique_path, image_binary, content_type: mime)
          |> ExAws.request()

        value =
          case image do
            {:ok, _} ->
              image_attrs = %{user_id: user_id, job_id: job.id, link: unique_path}
              {:ok, image} = Resources.create_image(image_attrs)

              %{id: image.id, link: image.link}

            _ ->
              :error
          end

        {:ok, value}
      end)

    cond do
      Enum.member?(uploaded_files, :error) ->
        Logger.debug("ERROR: #{inspect(uploaded_files)}")

      true ->
        uploaded_files =
          if is_map(uploaded_files) do
            [uploaded_files]
          else
            uploaded_files
          end

        _task =
          Task.Supervisor.start_child(Critique.TaskSupervisor, fn ->
            Runpod.run(job.id, uploaded_files)
          end)

        Phoenix.PubSub.broadcast(
          Critique.PubSub,
          "jobs:user:#{job.user_id}",
          {:new, job}
        )
    end

    updated_socket =
      socket
      |> push_navigate(to: ~p"/jobs/#{job.id}", replace: false)

    {:noreply, updated_socket}
  end

  def handle_info({:uploading, status}, socket) do
    IO.puts("UPLOADING INFO TRIGGERED")

    {:noreply,
     socket
     |> assign(:uploading, status)}
  end

  defp clear_uploads(socket, uploads_name) do
    entries = socket.assigns.uploads[uploads_name].entries

    Enum.reduce(entries, socket, fn entry, acc ->
      cancel_upload(acc, uploads_name, entry.ref)
    end)
  end

  def format_file_size(size) do
    case size do
      _ when size >= 1_048_576 -> "#{Float.round(size / 1_048_576.0, 1)} MB"
      _ when size >= 1024 -> "#{Float.round(size / 1024.0, 1)} KB"
      _ -> "#{size} B"
    end
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:external_client_failure), do: "External client failure"
end
