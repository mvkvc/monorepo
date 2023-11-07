# Configuration

The following configuration options are available as inputs in your `mix.exs`:

```elixir
  def project do
    [
      # ...
      lbdev: lbdev(),
    ]
  end

  defp lbdev do
    [
      notebooks: "notebooks", # Folder containing your Livebooks
      tags: [ # Tags are used at the start of a code block like with # BASE:TAG for example # export:lib
        base: "export", # Tag used to identify code blocks to extract
        lib: "lib", # Additional tag to identify code as application code
        test: "test" # Additional tag to identify code as test code
      ]
    ]
  end
```
