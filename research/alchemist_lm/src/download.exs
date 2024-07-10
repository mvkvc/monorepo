Mix.install([
  {:req, "~> 0.4.5"},
  {:req_hex, "~> 0.1.0"}
])

defmodule CLEHex do
  @repo "https://repo.hex.pm"
  @endings [".ex", ".exs"]
  @exclude [".formatter.exs"]
  @download_delay 100
  @download_retry 3
  @download_concurrency 10

  def ets_setup() do
    if :ets.info(:hex) == :undefined do
      :ets.new(:hex, [:set, :public, :named_table])
    end
  end

  def ets_check(package) when is_binary(package) do
    case :ets.lookup(:hex, package) do
      [{^package, download_count}] ->
        download_count

      [] ->
        download_count = 0
        ets_update(package, download_count)
        download_count
    end
  end

  def ets_update(package, download_count)
      when is_binary(package) and is_integer(download_count) do
    :ets.insert(:hex, {package, download_count})
  end

  def connect(opts \\ []) do
    repo = Keyword.get(opts, :repo, @repo)
    req = Req.new(base_url: repo) |> ReqHex.attach()

    req
  end

  def folder_path(path, package, version) do
    path
    |> Path.expand()
    |> Path.join("#{package}_%#{version}")
  end

  def get_names(req, opts \\ []) do
    # Not currently used but could filter by last updated and download count
    last_updated = Keyword.get(opts, :last_updated)
    last_updated = if last_updated, do: last_updated(last_updated), else: 0

    resp = req |> Req.get!(url: "/names")

    case resp do
      %Req.Response{status: 200, body: body} ->
        names =
          body
          |> Enum.filter(fn %{updated_at: %{seconds: seconds}} ->
            seconds > last_updated
          end)
          |> Enum.map(fn %{name: name} -> name end)

        {:ok, names}

      %Req.Response{status: status, body: body} ->
        {:error, "Failed to get names. Status: #{status}. Body: #{body}"}
    end
  end

  def extract(tarball, path, package) do
    files =
      tarball["contents.tar.gz"]
      |> Enum.filter(fn {name, _content} ->
        String.ends_with?(name, @endings) && !Enum.member?(@exclude, name)
      end)
      |> Enum.map(fn {name, content} -> {String.replace(name, "/", "_%"), content} end)

    if length(files) > 0 do
      File.mkdir_p!(path)

      Enum.map(files, fn {name, content} ->
        File.write!(Path.join(path, name), content)
      end)
    else
      IO.puts("No Elixir files found, skipping `#{package}`.")
    end
  end

  def download(req, package, path) do
    try do
      resp = Req.get!(req, url: "/versions").body |> Enum.find(&(&1.name == package))
      latest_version = Enum.max(resp.versions)
      path = folder_path(path, package, latest_version)

      if File.exists?(path) do
        IO.puts("Already downloaded `#{package}`.")
        {:ok, path}
      else
        tarball = Req.get!(req, url: "/tarballs/#{package}-#{latest_version}.tar").body

        case tarball do
          %{"contents.tar.gz" => _contents} ->
            IO.puts("Successfully downloaded `#{package}`.")
            extract(tarball, path, package)
            {:ok, path}

          _ ->
            statement = "Failed to download `#{package}`."
            IO.puts(statement)
            {:error, statement}
        end
      end
    rescue
      exception ->
        statement = "Failed due to #{Exception.message(exception)}."
        IO.puts(statement)
        {:error, statement}
    end
  end

  def download_with_retry(req, package, path) do
    download_count = ets_check(package)

    if download_count < @download_retry do
      download_count = download_count + 1
      ets_update(package, download_count)

      case download(req, package, path) do
        {:ok, path} ->
          {:ok, path}

        {:error, _reason} ->
          new_delay = @download_delay |> :math.pow(download_count) |> round()
          Process.sleep(new_delay)
          download_with_retry(req, package, path)
      end
    else
      {:error, "Failed to download `#{package}`. Reason: Retry limit reached."}
    end
  end

  def download_all(req, path, opts \\ []) do
    ets_setup()

    case get_names(req, opts) do
      {:ok, names} ->
        Task.async_stream(
          names,
          fn name -> download_with_retry(req, name, path) end,
          max_concurrency: @download_concurrency,
          on_timeout: :continue,
          on_exit: :continue
        )
        |> Enum.to_list()

      {:error, reason} ->
        IO.puts(reason)
    end
  end

  def last_updated(date_str) do
    {:ok, date} = Date.from_iso8601(date_str)

    datetime = %DateTime{
      year: date.year,
      month: date.month,
      day: date.day,
      utc_offset: 0,
      std_offset: 0,
      zone_abbr: "UTC",
      time_zone: "Etc/UTC",
      hour: 0,
      minute: 0,
      second: 0,
      microsecond: {0, 0}
    }

    utc_seconds = DateTime.to_unix(datetime, :second)

    utc_seconds
  end
end

req = CLEHex.connect()

get_path = fn ->
  IO.write("Please enter a path for the data folder: ")
  IO.gets("") |> String.trim()
end

path = get_path.() |> Path.expand()
File.mkdir_p(path)

unless File.exists?(path) and File.dir?(path) do
  raise "The path does not exist or is not a directory."
end

CLEHex.download_all(req, path)
