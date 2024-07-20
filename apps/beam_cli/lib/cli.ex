defmodule CLI do
  @moduledoc """
  Documentation for `CLI`.
  """
  def start(_, _) do
    # Returning `{:ok, pid}` will prevent the application from halting.
    # Use System.halt(exit_code) to terminate the VM when required
    args = Burrito.Util.Args.argv()
  end
end
