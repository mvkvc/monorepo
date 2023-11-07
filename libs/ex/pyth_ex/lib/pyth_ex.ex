defmodule PythEx do
  use Rustler,
      otp_app: :pyth_ex,
      crate: :pyth_ex

      @default_url "http:/pythnet.rpcpool.com"
      @mina_key "GHeTjLVXYzZycrSkgACCmQ1fH5eyy73XADLuEzC1rVSG"
      @max_delay 60

  # Add max_delay to options incl things like number to decimals to round to etc
  def query(), do: query(@default_url, @mina_key, @max_delay) / 1_000_000 |> round()
  def query(_url, _key, _max_delay), do: :erlang.nif_error(:nif_not_loaded)
end
