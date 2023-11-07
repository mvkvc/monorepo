defmodule Pokelixir do
  alias Pokelixir.Pokemon

  @spec get(String.t()) :: map()
  def get(name \\ "charizard") do
    case HTTPoison.get("https://pokeapi.co/api/v2/pokemon/#{name}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response = Jason.decode!(body)
        stats = response["stats"]

        stats = Enum.map(stats, fn x ->
          base_stat = Map.get(x, "base_stat")
          key = Kernel.get_in(x, ["stat", "name"])
          {:"#{key}", base_stat}
        end) |> IO.inspect()

        types = Enum.map(response["types"], fn x ->
          Kernel.get_in(x, ["type", "name"])
        end)

        %Pokelixir.Pokemon{
          name: response["name"],
          hp: stats[:hp],
          attack: stats[:attack],
          defense: stats[:defense],
          special_attack: stats[:"special-attack"],
          special_defense: stats[:"special-defense"],
          speed: stats[:speed],
          id: response["id"],
          height: response["height"],
          weight: response["weight"],
          types: types
        }
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("#{name} not found. Try another Pokemon!")
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end
end
