defmodule AkashiWeb.IDLive do
    use AkashiWeb, :live_view

    @impl true
    def render(assigns) do
        ~H"""
        <h1 class="text-3xl text-center">ID</h1>
        """
    end
        
    @impl true
    def mount(_params, _session, socket) do  
        {:ok, socket}
    end
end
