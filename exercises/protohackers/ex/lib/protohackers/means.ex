defmodule Protohackers.Means do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init([] = _opts) do
    {:ok, ifadr} = Application.fetch_env(:protohackers, :ifadr)
    {:ok, port} = Application.fetch_env(:protohackers, :port_means)

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
        Logger.info("Starting server on port: #{port}.")
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
        Logger.info("Error with reason: #{inspect(reason)}.")
    end
  end

  def handle_connection(socket) do
    case recv_until_close(socket, _history=[]) do
      {:ok, data} -> 
        {:ok, _data} = :gen_tcp.send(socket, data)
      {:error, :closed} ->
        :ok = :gen_tcp.close(socket)
      {:error, reason} -> Logger.info("Error with reason: #{inspect(reason)}")
    end
  end

  def recv_until_close(socket, history \\ []) do
    case(:gen_tcp.recv(socket, 0, 10_000)) do
      {:ok, <<"I"::utf8, first::32, second::32>>} -> 
        history = handle_insert(first, second, history)
        recv_until_close(socket, history)

      {:ok, <<"Q"::utf8, first::32, second::32>>} -> 
        response = handle_query(first, second, history)
        {:ok, _data} = :gen_tcp.send(socket, response)
        recv_until_close(socket, history)

      {:error, reason} -> {:error, reason}
      {:ok, bin} -> Logger.info("Malformed binary message: #{bin}")
    end
  end

  def handle_insert(first, second, history \\ []) do
    new_value = {first, second}
    [new_value | history]
  end

  def handle_query(first, second, history \\ []) do
    history
    |> Enum.filter(fn {k, _v} -> k > first || k < second end)
    |> Enum.reduce(0, fn {_k, v}, acc -> acc + v end)
    |> Kernel.div(length(history))
    |> round()
  end
end
