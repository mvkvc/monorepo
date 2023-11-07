#!/bin/bash

asdf install
mix do local.rebar --force --if-missing
mix do local.hex --force --if-missing
mix escript.install hex livebook
asdf reshim
