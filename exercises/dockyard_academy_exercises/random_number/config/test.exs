import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :random_number, RandomNumberWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "5rfNYTCMn/20YCRIOo+Wqo0g1Epv/DVslVEXtntt1FcU/9sgGnIdwH64t8n4ghTh",
  server: false

# In test we don't send emails.
config :random_number, RandomNumber.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
