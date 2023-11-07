#! /bin/bash

trap 'kill $(jobs -p)' SIGINT

(sh/db.sh) &
(iex -S mix phx.server) &
wait
