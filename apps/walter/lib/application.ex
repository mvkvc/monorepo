defmodule Walter.Application do
  use Application

  def start(_type, _args) do
    children = [
      Walter.Supervisor,
      {Task.Supervisor, name: Walter.TaskSupervisor}
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
