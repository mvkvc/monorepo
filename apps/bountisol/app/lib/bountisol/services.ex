defmodule Bountisol.Services do
  @moduledoc false
  alias Bountisol.Accounts

  def verify_signature(%{address: address, message: message, signature: signature} = params) do
    IO.inspect(params, label: "params")
    result = Portboy.run_pool(:js, "siws", %{message: message, signature: signature})
    IO.inspect(result, label: "result")

    if result do
      Accounts.get_user_by_address(address)
    end
  end
end
