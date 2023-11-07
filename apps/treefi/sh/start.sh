#! /bin/bash

trap 'kill $(jobs -p)' SIGINT

(sh/db.sh) &
(cd ./app && iex -S mix phx.server) &
(cd ./site && pnpm run dev) &
(cd ./withdraw && pnpm run dev) &
wait
