defmodule Train.Model.Vit do
  @behaviour Train.Model

  @impl
  def load() do
    # facebook/dino-vitb16 (larger model for run time)
    id = "facebook/dino-vits8"

    {:ok, spec} =
      Bumblebee.load_spec({:hf, id},
        architecture: :for_image_classification
      )

    spec = Bumblebee.configure(spec, num_labels: 2)

    {:ok, model} = Bumblebee.load_model({:hf, id}, spec: spec)
    {:ok, featurizer} = Bumblebee.load_featurizer({:hf, id})

    {model, featurizer}
  end
end
