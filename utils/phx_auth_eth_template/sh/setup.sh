#! /bin/bash

if [[ -z "$MIX_HOME" || -z "$HEX_HOME" ]]; then
    echo "Ensure the \$MIX_HOME and \$HEX_HOME environment variables are set. (Should be done in the Nix flake.)"
    exit 1
fi

echo "Installing Rebar, Hex, and Livebook..."
mkdir -p "$MIX_HOME" &&
mkdir -p "$HEX_HOME" &&
mix local.rebar --force --if-missing &&
mix "do" local.rebar --force --if-missing &&
mix "do" local.hex --force --if-missing &&
if [ ! -f "$MIX_HOME/escripts/livebook" ]; then mix escript.install hex livebook; fi

echo "Installing contract dependencies..."
(cd ./contracts && npm i -D && poetry install --with=dev)

echo "Installing app dependencies..."
(cd ./app && mix setup)

echo "Installing site dependencies..."
(cd ./site && poetry install --with=dev)
