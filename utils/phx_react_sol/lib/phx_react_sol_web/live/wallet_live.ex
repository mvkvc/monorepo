defmodule PhxReactSol.WalletLive do
  use PhxReactSolWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-row space-x-4 items-center">
      <p>Phoenix: </p>
      <button class="btn" phx-click="increment">Increment</button>
      <button class="btn" phx-click="reset">Reset</button>
      <p>React: </p>
      <%= live_react_component("Components.SolanaWalletConnector", [network: @network], id: "wallet") %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    network = if Mix.env() == :prod, do: "main", else: "dev"

    {:ok, assign(socket, network: network)}
  end

  @impl true
  def handle_event("increment", _value, socket) do
    {:noreply, push_event(socket, "increment", %{"amount" => :rand.uniform(10)})}
  end

  @impl true
  def handle_event("reset", _value, socket) do
    {:noreply, push_event(socket, "reset", %{})}
  end

  @impl true
  def handle_event(event, _value, socket) do
    IO.inspect(event, label: "EVENT")

    {:noreply, socket}
  end
end
