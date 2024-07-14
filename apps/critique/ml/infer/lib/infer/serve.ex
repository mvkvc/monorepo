defmodule Infer.Serve do
  require Logger
  # alias Infer.Runpod

  def predict(params) do
    # params = Runpod.decode(params)

    Logger.info("Predicting #{inspect(params)}")

    result =
      params
      |> Enum.map(fn %{id: id, link: _link} ->
        %{id: id, prediction: :rand.uniform() |> Float.round(2)}
      end)

    Logger.info("Result: #{inspect(result)}")

    result
  end
end
