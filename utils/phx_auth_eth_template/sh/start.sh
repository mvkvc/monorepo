#! /bin/bash

trap 'kill $(jobs -p)' SIGINT

(cd ./app && iex -S mix phx.server) &
(cd ./site && poetry run mkdocs serve) &
wait
