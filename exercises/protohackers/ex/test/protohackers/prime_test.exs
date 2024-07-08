defmodule Protohackers.PrimeTest do
  use ExUnit.Case, async: true

  test "returns true for prime" do
    {:ok, port} = Application.fetch_env(:protohackers, :port_prime)
    {:ok, socket} = :gen_tcp.connect(~c"localhost", port, mode: :binary, active: false)
    request = %{"method" => "isPrime", "number" => 7}
    request = Jason.encode!(request) <> "\n"
    assert :gen_tcp.send(socket, request) == :ok
    {:ok, data} = :gen_tcp.recv(socket, 0, 10_000)
    data = (String.ends_with?(data, "\n") && String.trim_trailing(data, "\n")) || data
    response = Jason.decode!(data)
    assert response == %{"method" => "isPrime", "prime" => true}
  end

  test "returns false for not prime" do
    {:ok, port} = Application.fetch_env(:protohackers, :port_prime)
    {:ok, socket} = :gen_tcp.connect(~c"localhost", port, mode: :binary, active: false)
    request = %{"method" => "isPrime", "number" => 12}
    request = Jason.encode!(request) <> "\n"
    assert :gen_tcp.send(socket, request) == :ok
    {:ok, data} = :gen_tcp.recv(socket, 0, 10_000)
    data = (String.ends_with?(data, "\n") && String.trim_trailing(data, "\n")) || data
    response = Jason.decode!(data)
    assert response == %{"method" => "isPrime", "prime" => false}
  end

  test "returns malformed for malformed" do
        {:ok, port} = Application.fetch_env(:protohackers, :port_prime)
    {:ok, socket} = :gen_tcp.connect(~c"localhost", port, mode: :binary, active: false)
    request = %{"method" => "isNotPrime", "numbers" => 999}
    request = Jason.encode!(request) <> "\n"
    assert :gen_tcp.send(socket, request) == :ok
    {:ok, response} = :gen_tcp.recv(socket, 0, 10_000)
    assert response == request
  end
end
