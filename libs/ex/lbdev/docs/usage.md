# Usage

Run `mix lbdev` in another terminal to watch for changes and automatically sync to your source file. If you pull a project locally and want to recreate all the source files, run `mix lbdev --sync`.

It is recommended to create an alias in your `mix.exs` to start the server and run the sync watcher simultaneously:

```elixir
defp aliases do
  [
    # ...
    "lbdev.server": ["cmd livebook server & mix lbdev"]
  ]
end
```
