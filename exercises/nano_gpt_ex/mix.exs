defmodule NanoGpt.MixProject do
  use Mix.Project

  @description "Elixir implementation of nanoGPT."
  @source_url "https://github.com/mvkvc/nano_gpt_ex"
  @version "0.1.0"

  def project do
    [
      app: :nano_gpt,
      description: @description,
      source_url: @source_url,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      aliases: aliases(),
      dialyzer: [
        plt_local_path: "dialyzer",
        plt_core_path: "dialyzer"
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp docs do
    [
      extras: [
        {:"README.md", [title: "Overview"]},
        "LICENSE.md"
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      # You can specify a function for adding
      # custom content to the generated HTML.
      # This is useful for custom JS/CSS files you want to include.
      before_closing_body_tag: &before_closing_body_tag/1
      # ...
    ]
  end

  # In our case we simply add a tags to load KaTeX
  # from CDN and then specify the configuration.
  # Once loaded, the script will dynamically render all LaTeX
  # expressions on the page in place.
  # For more details and options see https://katex.org/docs/autorender.html
  defp before_closing_body_tag(:html) do
    """
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.13.0/dist/katex.min.css" integrity="sha384-t5CR+zwDAROtph0PXGte6ia8heboACF9R5l/DiY+WZ3P2lxNgvJkQk5n7GPvLMYw" crossorigin="anonymous">
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.13.0/dist/katex.min.js" integrity="sha384-FaFLTlohFghEIZkw6VGwmf9ISTubWAVYW8tG8+w2LAIftJEULZABrF9PPFv+tVkH" crossorigin="anonymous"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.13.0/dist/contrib/auto-render.min.js" integrity="sha384-bHBqxz8fokvgoJ/sc17HODNxa42TlaEhB+w8ZJXTc2nZf1VgEaFZeZvT4Mznfz0v" crossorigin="anonymous"></script>
    <script>
      document.addEventListener("DOMContentLoaded", function() {
        renderMathInElement(document.body, {
          delimiters: [
            { left: "$$", right: "$$", display: true },
            { left: "$", right: "$", display: false },
          ]
        });
      });
    </script>
    """
  end

  defp before_closing_body_tag(_), do: ""

  defp deps do
    [
      {:axon, "~> 0.4"},
      {:exla, "~> 0.4"},
      {:nx, "~> 0.4"},
      {:jason, "~> 1.4"},
      {:httpoison, "~> 2.0"},
      {:hex_core, "~> 0.9.0"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      docs: "docs --formatter html --open"
    ]
  end
end
