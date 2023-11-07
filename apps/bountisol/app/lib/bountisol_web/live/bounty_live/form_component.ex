defmodule BountisolWeb.BountyLive.FormComponent do
  use BountisolWeb, :live_component

  alias Bountisol.Bounties

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage bounty records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="bounty-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:user_id]} type="text" readonly="true" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:summary]} type="text" label="Summary" />
        <.input field={@form[:requirements]} type="text" label="Requirements" />
        <.input field={@form[:deadline]} type="datetime" label="Deadline" />
        <.input field={@form[:gated]} type="select" options={["true", "false"]} label="Gated" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Bounty</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{bounty: bounty} = assigns, socket) do
    changeset = Bounties.change_bounty(bounty)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"bounty" => bounty_params}, socket) do
    changeset =
      socket.assigns.bounty
      |> Bounties.change_bounty(bounty_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"bounty" => bounty_params}, socket) do
    save_bounty(socket, socket.assigns.action, bounty_params)
  end

  defp save_bounty(socket, :edit, bounty_params) do
    case Bounties.update_bounty(socket.assigns.bounty, bounty_params) do
      {:ok, bounty} ->
        notify_parent({:saved, bounty})

        {:noreply,
         socket
         |> put_flash(:info, "Bounty updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_bounty(socket, :new, bounty_params) do
    case Bounties.create_bounty(bounty_params) do
      {:ok, bounty} ->
        notify_parent({:saved, bounty})

        {:noreply,
         socket
         |> put_flash(:info, "Bounty created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
