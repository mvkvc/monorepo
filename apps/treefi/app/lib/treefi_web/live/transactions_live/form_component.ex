defmodule TreeFiWeb.TransactionsLive.FormComponent do
  use TreeFiWeb, :live_component

  alias TreeFi.Payments

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage transactions records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="transactions-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:denomination]} type="text" label="Denomination" />
        <.input field={@form[:amount]} type="number" label="Amount" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Transactions</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{transactions: transactions} = assigns, socket) do
    changeset = Payments.change_transactions(transactions)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"transactions" => transactions_params}, socket) do
    changeset =
      socket.assigns.transactions
      |> Payments.change_transactions(transactions_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"transactions" => transactions_params}, socket) do
    save_transactions(socket, socket.assigns.action, transactions_params)
  end

  defp save_transactions(socket, :edit, transactions_params) do
    case Payments.update_transactions(socket.assigns.transactions, transactions_params) do
      {:ok, transactions} ->
        notify_parent({:saved, transactions})

        {:noreply,
         socket
         |> put_flash(:info, "Transactions updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_transactions(socket, :new, transactions_params) do
    case Payments.create_transactions(transactions_params) do
      {:ok, transactions} ->
        notify_parent({:saved, transactions})

        {:noreply,
         socket
         |> put_flash(:info, "Transactions created successfully")
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
