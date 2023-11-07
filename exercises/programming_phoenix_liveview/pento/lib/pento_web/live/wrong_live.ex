defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def mount(_params, session, socket) do
    {:ok,
     assign(socket, time: time(), target: Enum.random(1..10), score: 0, message: "Make a guess")}
  end

  def handle_event("guess", %{"number" => guess} = data, socket) do
    IO.inspect(socket.assigns)
    time = time()

    {message, score, target} =
      if String.to_integer(guess) == socket.assigns.target do
        message = "Your guess: #{guess}. Correct!"
        score = socket.assigns.score + 10
        target = Enum.random(1..10)

        {message, score, target}
      else
        message = "Your guess: #{guess}. Wrong. Guess Again."
        score = socket.assigns.score - 1
        target = socket.assigns.target

        {message, score, target}
      end

    {
      :noreply,
      assign(
        socket,
        time: time,
        target: target,
        score: score,
        message: message
      )
    }
  end

  def time do
    DateTime.utc_now() |> to_string()
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
      It's <%= @time %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number= {n} ><%= n %></a>
      <% end %>
    </h2>
    """
  end
end
