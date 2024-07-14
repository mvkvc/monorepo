defmodule TreeFiWeb.TransactionsLive.Index do
  use TreeFiWeb, :live_view

  alias TreeFi.Payments
  alias TreeFi.Payments.Transaction

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :transaction, Payments.list_transaction())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Transactions")
    |> assign(:transactions, Payments.get_transactions!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Transactions")
    |> assign(:transactions, %Transaction{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Transaction")
    |> assign(:transactions, nil)
  end

  @impl true
  def handle_info({TreeFiWeb.TransactionsLive.FormComponent, {:saved, transactions}}, socket) do
    {:noreply, stream_insert(socket, :transaction, transactions)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transactions = Payments.get_transactions!(id)
    {:ok, _} = Payments.delete_transactions(transactions)

    {:noreply, stream_delete(socket, :transaction, transactions)}
  end
end
