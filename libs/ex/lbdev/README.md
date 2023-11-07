# Lbdev

[![docs](https://github.com/mvkvc/lbdev/actions/workflows/docs.yaml/badge.svg?branch=main)](https://github.com/mvkvc/lbdev/actions/workflows/docs.yaml)
[![ci](https://github.com/mvkvc/lbdev/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/mvkvc/lbdev/actions/workflows/ci.yaml)

Inspired by [nbdev](https://github.com/fastai/nbdev), use [Livebooks](https://github.com/livebook-dev/livebook) to write, test, and document your Elixir code.

## Installation

```elixir
def deps do
  [
    {:lbdev, git: "https://github.com/mvkvc/lbdev.git", only: dev, runtime: false}
  ]
end
```
