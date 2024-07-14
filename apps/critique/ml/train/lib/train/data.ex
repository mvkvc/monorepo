defmodule Train.Data do
  require Explorer.DataFrame
  alias Explorer.DataFrame, as: DF
  alias Explorer.Series, as: Series

  def get_files(path) do
    if File.dir?(path) do
      path
      |> File.ls!()
      |> Enum.map(&Path.join(path, &1))
      |> Enum.flat_map(&get_files/1)
    else
      cond do
        String.ends_with?(path, [".jpg", ".jpeg", ".png"]) -> [path]
        true -> []
      end
    end
  end

  def build_df(path \\ "data/artifact-dataset") do
    csv_opts = [
      dtypes: %{
        "category" => :string,
        "filename" => :string,
        "image_path" => :string,
        "target" => :integer
      }
    ]

    real_images =
      MapSet.new(["afhq", "celebahq", "coco", "ffhq", "imagenet", "landscape", "lsun", "metfaces"])

    # Write a function that checks the string path and sees if is a member of real_images
    target_fn = fn real_images, x ->
      x
      # |> IO.inspect(label: "init")
      |> String.split("/")
      # |> IO.inspect(label: "split")
      |> Enum.at(2)
      # |> IO.inspect(label: "first")
      |> (&MapSet.member?(real_images, &1)).()
      # |> IO.inspect(label: "member")
      |> case do
        true -> 1
        false -> 0
      end

      # |> IO.inspect(label: "end")
    end

    # df =
    #   get_files(path)
    #   |> Enum.map(fn x -> DF.from_csv!(x <> "/metadata.csv", csv_opts) end)
    #   |> DF.concat_rows()
    #   |> DF.select(["image_path", "target"])
    paths =
      path
      |> get_files()

    df =
      Explorer.DataFrame.new(%{
        paths: paths |> Series.from_list()
      })

    # image_path = DF.to_series(df) |> Map.get("image_path") |> Series.to_list()
    target_computed = Enum.map(paths, fn x -> target_fn.(real_images, x) end)
    # target_computed |> Enum.frequencies() |> IO.inspect(label: "target")

    df = DF.put(df, "target", target_computed)
    DF.to_csv!(df, "labels.csv")
    df
  end

  def load_df(path_data \\ "data/artifact-dataset", path_df \\ "labels.csv", force \\ false) do
    df =
      if !File.exists?(path_df) or force do
        build_df(path_data)
      else
        DF.from_csv!(path_df)
      end

    # build_df(path_data)
  end

  def load_image(path) do
    path
    |> Image.open!()
    |> Image.to_nx!()
  end

  def load(
        batch_size \\ 32,
        path_data \\ "data/artifact-dataset",
        path_df \\ "labels.csv",
        force \\ true,
        split \\ 0.3
      ) do
    df = load_df(path_data, path_df, force)
    df = DF.shuffle(df)

    # stream =
    #   df
    #   |> DF.to_columns()
    #   |> Stream.zip()

    paths = df["paths"]
    target = df["target"]

    stream =
      paths
      |> Explorer.Series.to_enum()
      |> Stream.zip(Explorer.Series.to_enum(target))

    stream
    |> Stream.chunk_every(batch_size)
    |> Stream.map(fn batch ->
      {paths, targets} = Enum.unzip(batch)
      loaded = Enum.map(paths, &load_image/1)
      {Nx.stack(loaded), Nx.stack(targets)}
    end)
  end
end
