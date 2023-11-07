#! /bin/bash

export MIX_ENV=test

mix test
mix format --check-formatted
mix credo --strict
mix dialyzer --halt-exit-status
