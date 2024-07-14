defmodule TreeFiWeb.TransactionsLive.Show do
  use TreeFiWeb, :live_view

  alias TreeFi.Payments

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:transactions, Payments.get_transactions!(id))}
  end

  defp page_title(:show), do: "Show Transactions"
  defp page_title(:edit), do: "Edit Transactions"
end
