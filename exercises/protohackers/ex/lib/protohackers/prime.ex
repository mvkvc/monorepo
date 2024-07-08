defmodule Protohackers.Prime do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init([] = _opts) do
    {:ok, ifadr} = Application.fetch_env(:protohackers, :ifadr)
    {:ok, port} = Application.fetch_env(:protohackers, :port_prime)

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
        Logger.info("Error #{inspect(reason)}")
    end
  end

  def handle_connection(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0, 10_000)

    case Jason.decode(data) do
      {:ok, %{"method" => "isPrime", "number" => number}} ->
        Logger.info("Repsonse accepted with num: #{number}")
        is_prime = isPrime?(number)

        response =
          %{"method" => "isPrime", "prime" => is_prime}
          |> Jason.encode!()
          |> (fn x -> Enum.join([x, "\n"]) end).()
          |> IO.inspect()

        :gen_tcp.send(socket, response)

      {:error, reason} ->
        Logger.info("Response malformed #{inspect(reason)}.")
        :ok = :gen_tcp.send(socket, data)
        :ok = :gen_tcp.close(socket)

      _ ->
        :ok = :gen_tcp.send(socket, data)
        :ok = :gen_tcp.close(socket)
    end
  end

  def isPrime?(number, divisor \\ 2) do
    cond do
      Enum.member?([0, 1], number) -> false
      divisor >= :math.sqrt(number) -> true
      rem(number, divisor) != 0 -> isPrime?(number, divisor + 1)
      true -> false
    end
  end
end
