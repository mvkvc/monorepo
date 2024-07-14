defmodule Mix.Tasks.Start do
  use Mix.Task

  def run(_) do
    tasks = [
      Task.async(fn -> Mix.Task.run("tailwind.watch") end),
      Task.async(fn -> Mix.Task.run("phx.server") end)
      # Error: Your programs version (12) is lower than your repos (13). Please update ipfs to a version that supports the existing repo, or run a migration in reverse.
      # Task.async(fn -> Mix.Task.run("cmd", ["ipfs daemon"]) end)
    ]

    tasks
    |> Enum.map(&Task.await(&1, :infinity))
  end
end
