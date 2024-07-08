defmodule Exboost.Search.Result do
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:url, :content]}
  defstruct url: nil, content: nil

  @type t :: %__MODULE__{
          url: String.t(),
          content: String.t()
        }
end
