import Config

config :protohackers,
  ifadr: {0, 0, 0, 0},
  ipadr: ~c"localhost",
  port_echo: 5000,
  port_prime: 5001,
  port_means: 5002,
  port_chat: 5003

# import_config "#{config_env()}.exs"
