# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :critique,
  ecto_repos: [Critique.Repo]

# Configures the endpoint
config :critique, CritiqueWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: CritiqueWeb.ErrorHTML, json: CritiqueWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Critique.PubSub,
  live_view: [signing_salt: "P2xl6qjF"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :critique, Critique.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# config :critique, Oban,
#   repo: Critique.Repo,
#   plugins: [Oban.Plugins.Pruner],
#   queues: [default: 10]

config :ex_aws, :s3,
  scheme: "https://",
  # Trying without the bucket name
  # host: "bf8c417b2ced5730a7ffeaa24a5cfb8d.r2.cloudflarestorage.com/"
  host: "bf8c417b2ced5730a7ffeaa24a5cfb8d.r2.cloudflarestorage.com/critique"

config :kaffy,
  otp_app: :critique,
  ecto_repo: Critique.Repo,
  router: CritiqueWeb.Router

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
