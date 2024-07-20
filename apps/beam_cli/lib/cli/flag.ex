defmodule CLI.Flag do
  defstruct [
    :short,
    :long,
    :type,
    :default,
    :description
  ]
end
