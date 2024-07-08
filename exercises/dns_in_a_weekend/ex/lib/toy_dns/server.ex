defmodule ToyDns.Server do
  @moduledoc false

  use GenServer

  def init(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end
end
