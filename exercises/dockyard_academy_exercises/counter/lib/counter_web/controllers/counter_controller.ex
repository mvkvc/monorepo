defmodule CounterWeb.CounterController do
  use CounterWeb, :controller

  def index(conn, params) do
    count = Counter.Count.get()
    render(conn, "index.html", count: count)
  end

  def update(conn, _params) do
    IO.inspect(conn.params)
    increment = case Integer.parse(conn.params["increment"]) do
      {value, _} -> value
      _ -> 1
    end
    Counter.Count.increment(increment)
    # redirect(conn, to: "/counter?increment=#{increment}")
    redirect(conn, to: Routes.counter_path(conn, :update, increment: increment))
  end
end
