defmodule Mix.Tasks.Ports do
  @moduledoc false
  use Mix.Task

  def run(_) do
    System.cmd("yarn", ["install"], cd: "./ports/js")
    System.cmd("yarn", ["run", "build"], cd: "./ports/js")
    File.cp_r!("./ports/js/dist", "./priv/ports/js")
  end
end
