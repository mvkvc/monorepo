#! /bin/bash

trap 'kill $(jobs -p)' SIGINT

(sh/db.sh) &

sleep 3

(mix ecto.migrate && iex -S mix phx.server) &
wait
