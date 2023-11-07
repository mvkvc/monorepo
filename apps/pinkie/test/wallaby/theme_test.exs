defmodule Pinkie.ThemeTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  feature "wallaby starts", %{session: session} do
    session
    |> visit("/home")
    |> take_screenshot(name: "theme-default")
    |> click(Query.button("toggle-darkmode"))
    |> take_screenshot(name: "theme-toggle")
  end
end
