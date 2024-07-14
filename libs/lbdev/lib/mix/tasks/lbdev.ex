defmodule Mix.Tasks.Lbdev do
  use Mix.Task

  def parse(args) do
    {opts, _, _} = OptionParser.parse(args, switches: [rebuild: :boolean])
    opts
  end

  def recursive_ls(dir) do
    dir
    |> Path.join("**/*")
    |> Path.wildcard()
    |> Enum.filter(&File.regular?/1)
  end

  def run(args) do
    opts = parse(args)
    rebuild = Keyword.get(opts, :rebuild, false)

    config_default = [
      notebooks: "notebooks",
      tags: [
        base: "export",
        lib: "lib",
        test: "test"
      ]
    ]

    config_mix = Mix.Project.config()
    config = config_mix[:lbdev] || []
    config = Keyword.merge(config_default, config)

    if rebuild do
      files = recursive_ls(config[:notebooks])

      for path <- files do
        Lbdev.Build.build(config, path)
        # IO.inspect(file)
      end
    end

    GenServer.start_link(Lbdev.Watcher,
      tags: config[:tags],
      fs: [dirs: [config[:notebooks]], name: Lbdev.Watcher]
    )

    IO.puts("Running Lbdev.Watcher...")

    Process.sleep(:infinity)
  end
end
