defmodule BountisolWeb.WalletLive do
  @moduledoc false
  use BountisolWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= live_react_component(
        "Components.WalletAdapter",
        [network_type: Application.get_env(:bountisol, :network)],
        id: "wallet"
      ) %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
