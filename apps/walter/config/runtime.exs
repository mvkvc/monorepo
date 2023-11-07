import Config

if Config.config_env() == :dev do
  DotenvParser.load_file(".secret")
end

config :rope,
  model: "gpt-3.5",
  api_key: System.get_env("OPENAI_API_KEY")

config :nostrum,
  token: System.get_env("DISCORD_BOT_TOKEN"),
  # Requesting everything for now until I figure out what I need
  gateway_intents: [
    :guilds,
    :guild_bans,
    :guild_emojis,
    :guild_integrations,
    :guild_webhooks,
    :guild_invites,
    :guild_voice_states,
    :guild_messages,
    :guild_message_reactions,
    :guild_message_typing,
    :direct_messages,
    :direct_message_reactions,
    :direct_message_typing,
    :message_content,
    :guild_scheduled_events
  ]
