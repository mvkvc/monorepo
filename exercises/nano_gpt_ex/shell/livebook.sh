#!/bin/bash

if command -v livebook &> /dev/null; then
    echo "livebook command found, starting..."
    source .env && livebook server
else
    echo "livebook command could not be found, installing..."
    mix do local.rebar --force, local.hex --force
    mix escript.install hex livebook
fi
