defmodule PinkieWeb.Components.Status do
  use Phoenix.Component

  # Add variable sizes and customization

  def icon(assigns) do
    IO.inspect(assigns)

    case assigns[:text] do
      "available" -> available(assigns)
      "unavailable" -> unavailable(assigns)
      _ -> unknown(assigns)
    end
  end

  def available(assigns) do
    ~H"""
    <span class="inline-flex items-center bg-green-100 text-green-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full dark:bg-green-900 dark:text-green-300">
      <span class="w-2 h-2 mr-1 bg-green-500 rounded-full"></span>
      Available
    </span>
    """
  end

  def unavailable(assigns) do
    ~H"""
    <span class="inline-flex items-center bg-red-100 text-red-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full dark:bg-red-900 dark:text-red-300">
      <span class="w-2 h-2 mr-1 bg-red-500 rounded-full"></span>
      Unavailable
    </span>
    """
  end

  def unknown(assigns) do
    text = assigns[:text] || "Unknown"

    ~H"""
    <span class="inline-flex items-center bg-gray-100 text-gray-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full dark:bg-gray-900 dark:text-gray-300">
      <span class="w-2 h-2 mr-1 bg-gray-500 rounded-full"></span>
      <%= text %>
    </span>
    """
  end
end
