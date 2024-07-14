#!/bin/bash

if [ "$1" == "--local" ]; then
  parallel --halt now,fail=1,success=1 ::: "mix run --no-halt" "python3.10 -u py/handler.py"
else
  mix run --no-halt & python3.10 -u py/handler.py
fi
