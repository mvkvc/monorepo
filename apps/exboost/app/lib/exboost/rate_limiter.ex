defmodule Exboost.RateLimiter do
  @cache :rate_limiter

  defp reset(), do: Application.get_env(:exboost, :rate_limit_reset_mins, 60)
  defp amount(), do: Application.get_env(:exboost, :rate_limit_amount, 10)
  defp ms_to_mins(ms) when is_integer(ms), do: ms / (60 * 1000)
  defp mins_to_ms(mins) when is_integer(mins), do: mins * 60 * 1000

  def get_quota(user_id) do
    amount =
      case Cachex.get(@cache, user_id) do
        {:ok, nil} -> amount()
        {:ok, count} -> max(count, 0)
        _ -> amount()
      end

    reset =
      case Cachex.ttl(@cache, user_id) do
        {:ok, nil} -> reset()
        {:ok, ttl} -> ms_to_mins(ttl)
        _ -> reset()
      end

    {amount, reset}
  end

  def decr(user_id) do
    case Cachex.get(@cache, user_id) do
      {:ok, nil} ->
        Cachex.put(@cache, user_id, amount(), ttl: mins_to_ms(reset()))

      {:ok, _count} ->
        Cachex.decr(@cache, user_id)
    end
  end
end
