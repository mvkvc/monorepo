defmodule NanoGpt.Hex do
  def get_config do
    :hex_core.default_config()
  end

  def response_to_map({_, {_, _, map}}) do
    map
  end

  def get_packages(config) do
    response = :hex_repo.get_names(config)
    response_to_map(response).packages
  end

  def filter_by_downloads(packages, min_downloads) do
    if min_downloads do
      packages
      |> Enum.filter(fn %{downloads: downloads} -> downloads > min_downloads end)
    else
      packages
    end
  end

  def filter_by_update(packages, amount, interval) do
    if amount && interval do
      packages
      |> Enum.filter(fn %{updated: updated} ->
        updated >
          DateTime.utc_now()
          |> DateTime.add(amount, interval)
          |> DateTime.to_unix()
      end)
    else
      packages
    end
  end

  def extract_info(body) do
    %{
      name: body["name"],
      latest_version: body["latest_version"],
      downloads: body["downloads"]["all"],
      updated: body["updated_at"]
    }
  end

  def get_info_list(config, opts \\ []) do
    opts = Keyword.put(opts, :rate_limit, 100)

    wait_amount = round(60 / opts[:rate_limit] * 1.1 * 1000)

    packages =
      get_packages(config)
      |> Enum.map(extract_info(&get_info(&1, wait_amount)))
      |> filter_by_update(opts[:date_amount], opts[:date_interval])
      |> filter_by_downloads(opts[:min_downloads])
      |> Enum.sort(fn %{downloads: a}, %{downloads: b} -> a > b end)

    if opts[:n_downloads] do
      Enum.take(packages, opts[:n_downloads])
    else
      packages
    end
  end

  def get_info(package_name, wait_amount \\ 0) do
    api_key = System.get_env("HEX_API_KEY")
    headers = [{"Authorization", "Bearer " <> api_key}]

    IO.puts("Getting info for #{package_name}...")

    Process.sleep(wait_amount)

    %HTTPoison.Response{status_code: 200, body: body} =
      HTTPoison.get!("https://hex.pm/api/packages/#{package_name}", [], headers)

    IO.puts("Got info for #{package_name}!")

    Jason.decode!(body)
  end

  def download(config, folder, name, version) do
    IO.puts("Downloading #{name}...")

    :hex_repo.get_tarball(config, name, version)
    |> response_to_map()
    # Downloads but raises an error
    |> :hex_tarball.unpack("#{folder}/#{name}")

    IO.puts("Downloaded #{name}!")
  end

  def download_all(config, folder, opts \\ []) do
    info_list = get_info_list(config, opts)

    case File.stat(folder) do
      {:error, _} -> File.mkdir(folder)
      _ -> :ok
    end

    Enum.map(info_list, fn %{name: name, latest_version: version} ->
      download(config, folder, name, version)
    end)
  end
end
