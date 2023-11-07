defmodule StackTest do
  use ExUnit.Case
  doctest Stack

  describe "start_link/1" do
    test "with no configuration" do
      {:ok, pid} = Stack.start_link([])
      assert Process.alive?(pid)
    end

    test "with a default state" do
      {:ok, pid} = Stack.start_link(state: [1, 2, 3])
      assert Process.alive?(pid)
    end
  end

  describe "push/2" do
    test "an element onto an empty stack" do
      {:ok, pid} = Stack.start_link([])
      Stack.push(pid, 1)
      assert [1] == GenServer.call(pid, :get_stack)
    end

    test "an element onto a stack with one element" do
      {:ok, pid} = Stack.start_link([1])
      Stack.push(pid, 2)
      assert [2, 1] == GenServer.call(pid, :get_stack)
    end

    test "an element onto a stack with multiple elements" do
      {:ok, pid} = Stack.start_link([2, 1])
      Stack.push(pid, 3)
      assert [3, 2, 1] == GenServer.call(pid, :get_stack)
    end
  end

  describe "pop/1" do
    test "an empty stack" do
      {:ok, pid} = Stack.start_link([])
      assert [] == Stack.pop(pid)
      assert [] == Stack.get_stack(pid)
    end

    test "a stack with one element" do
      {:ok, pid} = Stack.start_link([1])
      assert 1 == Stack.pop(pid)
      assert [] == Stack.get_stack(pid)
    end

    test "a stack with multiple elements" do
      {:ok, pid} = Stack.start_link([1, 2])
      assert 1 == Stack.pop(pid)
      assert [2] == Stack.get_stack(pid)
    end
  end
end
