defmodule Protohackers.EchoTest do
  use ExUnit.Case, async: true

  test "echoes anything back" do
    {:ok, port} = Application.fetch_env(:protohackers, :port_echo)
    {:ok, socket} = :gen_tcp.connect(~c"localhost", port, mode: :binary, active: false)
    assert :gen_tcp.send(socket, "foo") == :ok
    assert :gen_tcp.send(socket, "bar") == :ok
    :gen_tcp.shutdown(socket, :write)
    assert :gen_tcp.recv(socket, 0, 5000) == {:ok, "foobar"}
  end

  test "can handle multiple connections" do
    tasks =
      for i <- 1..4 do
        IO.puts("Starting connection #{i}")

        Task.async(fn ->
          IO.puts("Starting connection #{i}")
          {:ok, socket} = :gen_tcp.connect(~c"localhost", 5001, mode: :binary, active: false)
          assert :gen_tcp.send(socket, "foo") == :ok
          assert :gen_tcp.send(socket, "bar") == :ok
          :gen_tcp.shutdown(socket, :write)
          IO.puts("Shutting down connection #{i}")
          assert :gen_tcp.recv(socket, 0, 5000) == {:ok, "foobar"}
        end)
      end

    Enum.each(tasks, &Task.await/1)
  end
end
