defmodule Protohackers.Echo do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init([] = _opts) do
    {:ok, ifadr} = Application.fetch_env(:protohackers, :ifadr)
    {:ok, port} = Application.fetch_env(:protohackers, :port_echo)

    {:ok, supervisor} = Task.Supervisor.start_link(max_children: 100)

    listen_opts = [
      ifaddr: ifadr,
      mode: :binary,
      active: false,
      reuseaddr: true,
      exit_on_close: false
    ]

    case :gen_tcp.listen(port, listen_opts) do
      {:ok, listen_socket} ->
        Logger.info("Starting server on port #{port}.")
        state = %{listen_socket: listen_socket, supervisor: supervisor}
        {:ok, state, {:continue, :accept}}

      {:error, reason} ->
        {:stop, reason}
    end
  end

  @impl true
  def handle_continue(:accept, state) do
    case :gen_tcp.accept(state.listen_socket) do
      {:ok, socket} ->
        Task.Supervisor.start_child(state.supervisor, fn -> handle_connection(socket) end)
        {:noreply, state, {:continue, :accept}}

      {:error, reason} ->
        {:stop, reason}
    end
  end

  defp handle_connection(socket) do
    case recv_until_closed(socket, _buffer = "") do
      {:ok, data} -> :gen_tcp.send(socket, data)
      {:error, reason} -> Logger.info("Error reason #{inspect(reason)}")
    end

    :gen_tcp.close(socket)
  end

  defp recv_until_closed(socket, buffer) do
    case :gen_tcp.recv(socket, 0, 10_000) do
      {:ok, data} -> recv_until_closed(socket, [buffer, data])
      {:error, :closed} -> {:ok, buffer}
      {:error, reason} -> {:stop, reason}
    end
  end
end
