defmodule Walter.Consumer do
  use Nostrum.Consumer
  alias Nostrum.Api
  require Logger

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    IO.inspect(msg.content, label: "Received message")
    # IO.inspect(msg.author.username, label: "From")
    # IO.inspect(msg.channel_id, label: "Channel")
    # IO.inspect(ws_state, label: "WS State")
    case msg.content do
      "!ping" ->
        Api.create_message(msg.channel_id, "pyongyang!")

      "!remind " <> rest  ->
        [time, message] = String.split(rest, " ", parts: 2)
        Api.create_message(msg.channel_id, "I'll remind you in #{time} to #{message}")
        Process.sleep(3000)
        Api.create_message(msg.channel_id, "Reminder: #{message}")

      text ->
        IO.puts("Unhandled message: #{text}")
        :ignore
    end
  end

  def handle_event({event, _params, _state}) do
    IO.inspect(event, label: "Unhandled event")
    :noop
  end
end
