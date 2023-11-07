#! /bin/bash

trap 'kill $(jobs -p)' SIGINT

(sh/db.sh) &
(mix ecto.migrate && iex -S mix phx.server) &
wait
