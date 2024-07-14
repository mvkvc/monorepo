defmodule BountisolWeb.SignInLive do
  @moduledoc false
  use BountisolWeb, :live_view

  alias Bountisol.Accounts

  @statement """
  You are signing this message with your Solana wallet to sign in to Bountisol.
  """

  @impl true
  def render(assigns) do
    ~H"""
    <div id="wallet" class="flex flex-row space-x-4" phx-hook="Wallet">
      <%= if !@current_user do %>
        <%= if @connected do %>
          <.form
            for={%{}}
            action={~p"/users/log_in"}
            as={:user}
            phx-submit="verify"
            phx-trigger-action={@trigger_sign_in}
          >
            <.input type="hidden" name="address" value={@address} />
            <%!-- <p>
              <%= @address %>
            </p> --%>
            <.input type="hidden" name="message" value={@message} />
            <%!-- <p>
              <%= @message %>
            </p> --%>
            <.input type="hidden" name="signature" value={@signature} />
            <%!-- <p>
              <%= @signature %>
            </p> --%>
            <button class="btn">
              Sign in
            </button>
          </.form>
        <% else %>
          <button class="btn" disabled>
            Sign in
          </button>
        <% end %>
      <% else %>
        <.form
          for={%{}}
          action={~p"/users/log_out"}
          as={:user}
          method="delete"
          phx-trigger-action={@trigger_sign_out}
        >
          <button type="submit" class="btn">Log out</button>
        </.form>
      <% end %>
      <div class="min-w-36 bg-purple-100 rounded-lg shadow-md">
        <%= live_react_component(
          "Components.WalletAdapter",
          [network_type: Application.get_env(:bountisol, Bountisol.WalletLive)[:network]],
          id: "wallet-adapter"
        ) %>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)

    {:ok,
     assign(socket,
       trigger_sign_in: false,
       trigger_sign_out: false,
       connected: false,
       verified: false,
       address: nil,
       message: nil,
       signature: nil,
       wallet: nil
     )}
  end

  @impl true
  def handle_event("verify", _params, socket) do
    address = socket.assigns.address
    {:ok, _user} = Accounts.create_user_if_not_exists(address)

    nonce =
      case Accounts.get_user_by_address(address) do
        nil -> Accounts.generate_account_nonce()
        user -> user.nonce
      end

    {:noreply,
     push_event(socket, "signature", %{
       wallet: socket.assigns.wallet,
       address: address,
       statement: @statement,
       nonce: nonce
     })}
  end

  @impl true
  def handle_event("sign_out", _params, socket) do
    IO.puts("SIGN OUT TRIGGERED")

    {:noreply,
     socket
     |> assign(verified: false)
     |> assign(trigger_sign_out: true)}
  end

  @impl true
  def handle_event("verify-signature", %{"signature" => signature, "message" => message}, socket) do
    {:noreply,
     socket
     |> assign(signature: signature)
     |> assign(message: message)
     |> assign(trigger_sign_in: true)}
  end

  @impl true
  def handle_event("effect_connected", %{"wallet" => wallet}, socket) do
    {:noreply,
     socket
     |> assign(connected: true)
     |> assign(wallet: wallet)
     |> push_event("test", %{hello: "there"})}
  end

  @impl true
  def handle_event("effect_disconnecting", _params, socket) do
    push_event(socket, "sign_out", %{})

    {:noreply,
     socket
     |> assign(connected: false)
     |> assign(address: nil)
     |> assign(verified: false)
     |> assign(trigger_sign_out: true)}
  end

  @impl true
  def handle_event("effect_public_key", %{"public_key" => public_key}, socket) do
    {:noreply, assign(socket, address: public_key)}
  end

  defp assign_current_user(socket, session) do
    case session do
      %{"user_token" => user_token} ->
        assign_new(socket, :current_user, fn ->
          Accounts.get_user_by_session_token(user_token)
        end)

      %{} ->
        assign_new(socket, :current_user, fn -> nil end)
    end
  end
end
