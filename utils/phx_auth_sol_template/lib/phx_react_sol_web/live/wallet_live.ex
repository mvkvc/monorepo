defmodule PhxReactSol.WalletLive do
    use PhxReactSolWeb, :live_view
  
    @impl true
    def render(assigns) do
      ~H"""
      <div class="flex flex-row space-x-4 items-center">
        <p>PHOENIX =></p>
        <button class="btn" phx-click="increment">Increment</button>
        <button class="btn" phx-click="reset">Reset</button>
        <p>REACT =></p>
        <%= live_react_component("Components.SolanaWalletConnector", [network: @network], id: "wallet") %>
      </div>
      """
    end
  
    @impl true
    def mount(_params, _session, socket) do
        network = if Mix.env() == :prod, do: "main", else: "dev"
        {:ok, socket |> assign(network: network)}
    end

    @impl true
    def handle_event("increment", _value, socket) do
        amount = :rand.uniform(10)
        {:noreply, socket |> push_event("increment", %{"amount" => amount})}
    end

    @impl true
    def handle_event("reset", _value, socket) do
        {:noreply, socket |> push_event("reset", %{})}
    end

    @impl true
    def handle_event(event, _value, socket) do
        event |> IO.inspect(label: "REACT EVENT")
        {:noreply, socket}
    end
  end
  