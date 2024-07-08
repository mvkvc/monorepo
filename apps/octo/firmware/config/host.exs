import Config

# Add configuration that is only needed when running on the host here.

config :octo, Octo.Repo,
  database: Path.expand("../octo.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  show_sensitive_data_on_connection_error: true

config :octo_firmware, :viewport,
  size: {400, 300},
  theme: :light,
  default_scene: OctoFirmware.Scene.Home,
  drivers: [
    [
      module: Scenic.Driver.Local,
      window: [title: "octo_firmware"],
      on_close: :stop_system
    ]
  ]

case Mix.env() do
  :dev ->
    config :exsync,
      reload_timeout: 150,
      reload_callback: {ScenicLiveReload, :reload_current_scenes, []}

  _ ->
    nil
end

config :nerves_runtime,
  kv_backend:
    {Nerves.Runtime.KVBackend.InMemory,
     contents: %{
       # The KV store on Nerves systems is typically read from UBoot-env, but
       # this allows us to use a pre-populated InMemory store when running on
       # host for development and testing.
       #
       # https://hexdocs.pm/nerves_runtime/readme.html#using-nerves_runtime-in-tests
       # https://hexdocs.pm/nerves_runtime/readme.html#nerves-system-and-firmware-metadata

       "nerves_fw_active" => "a",
       "a.nerves_fw_architecture" => "generic",
       "a.nerves_fw_description" => "N/A",
       "a.nerves_fw_platform" => "host",
       "a.nerves_fw_version" => "0.0.0"
     }}

import_config "../../app/config/config.exs"