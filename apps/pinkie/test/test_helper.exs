ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Pinkie.Repo, :auto)
{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, PinkieWeb.Endpoint.url())
