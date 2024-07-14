defmodule TreeFi.Prices do
  use GenServer

  # These should be set in config and passed in as opts 
  @url "https://pro-api.coinmarketcap.com/v2/cryptocurrency/quotes/latest"
  @symbols ["ETH", "USDC", "USDT"]
  @table_name :prices
  # 10 minutes
  @update_interval 1_000 * 60 * 10
  # Max 15, round only when showing to user
  @precision 15
  # 5 seconds
  @retry_interval 1_000 * 5

  def dump() do
    :ets.tab2list(@table_name) |> Enum.into(%{})
  end

  def read([_head | _tail] = symbols) do
    tickers = :ets.match(:prices, {:"$1", :_}) |> List.flatten()

    if length(symbols -- tickers) > 0 do
      {:error, :unknown_symbols}
    else
      result =
        Enum.reduce(symbols, %{}, fn symbol, acc ->
          [{symbol, price}] = :ets.match_object(@table_name, {symbol, :"$1"})
          Map.put(acc, symbol, price)
        end)

      {:ok, result}
    end
  end

  def update() do
    send(self(), :update)
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # 

  def init(_opts) do
    System.fetch_env!("COINMARKETCAP_API_KEY")

    if :ets.whereis(@table_name) == :undefined do
      :ets.new(@table_name, [:named_table, :set, :public])
    end

    # symbols = Keyword.fetch!(opts, :symbols)

    state = %{
      symbols: @symbols,
      last_updated: nil,
      retry_counter: 0
    }

    {:ok, state, {:continue, :update}}
  end

  def handle_continue(:update, state) do
    # Replace this with `with`
    case fetch_prices(@symbols) do
      {:ok, prices} ->
        :ets.insert(@table_name, prices)
        Process.send_after(self(), :update, @update_interval)

        {:noreply,
         state
         |> Map.put(:last_updated, DateTime.utc_now())
         |> Map.put(:retry_counter, 0)}

      {:error, _status} ->
        new_retry_counter = state.retry_counter + 1
        Process.send_after(self(), :update, @retry_interval * new_retry_counter)

        {:noreply,
         state
         |> Map.put(:retry_counter, new_retry_counter)}
    end
  end

  def handle_info(:update, state) do
    {:noreply, state, {:continue, :update}}
  end

  def fetch_prices([_hd | _tl] = symbols) do
    headers = [
      {"Content-Type", "application/json"},
      {"X-CMC_PRO_API_KEY", System.get_env("COINMARKETCAP_API_KEY")}
    ]

    params = [symbol: Enum.join(symbols, ",")]
    response = Req.get!(@url, params: params, headers: headers)

    case response do
      %Req.Response{status: 200, body: body} ->
        data = Map.get(body, "data")
        {:ok, format_response(data)}

      %Req.Response{status: status} ->
        {:error, status}
    end
  end

  defp format_response(response) do
    Enum.map(response, fn {symbol, data} ->
      price =
        data
        |> List.first()
        |> get_in(["quote", "USD", "price"])
        |> Float.round(@precision)

      {symbol, price}
    end)
  end
end
