#!/bin/bash

set +a
source .env
set -a

TS=$(date +%y_%m_%d)

nixpacks detect .
nixpacks plan .
nixpacks build \
  -n "${DOCKER_IMAGE}":latest \
  -t "${DOCKER_IMAGE}":"$TS" \
  .
