defmodule CLI.Argument do
  defstruct [
    :key,
    :name,
    :description,
    :flags,
    :arguments
  ]

  def new(opts \\ []) do
    struct(__MODULE__, opts)
  end
end
