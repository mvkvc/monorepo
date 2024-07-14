#! /bin/bash

if [[ -z "$MIX_HOME" || -z "$HEX_HOME" ]]; then
    echo "Ensure the \$MIX_HOME and \$HEX_HOME environment variables are set. (Should be done in the Nix flake.)"
    exit 1
fi

echo "Installing Poetry..."
pipx install poetry

echo "Installing Rebar, Hex, and Livebook..."
mkdir -p "$MIX_HOME" &&
mkdir -p "$HEX_HOME" &&
mix local.rebar --force --if-missing &&
mix "do" local.rebar --force --if-missing &&
mix "do" local.hex --force --if-missing &&
if [ ! -f "$MIX_HOME/escripts/livebook" ]; then mix escript.install hex livebook --force; fi

echo "Installing app/ dependencies..."
(cd ./app && mix setup)

echo "Installing vault/ dependencies..."
(cd ./vault && poetry install)

echo "Installing site/ dependencies..."
(cd ./site && pnpm i)

echo "Installing withdraw/ dependencies..."
(cd ./withdraw && pnpm i)
