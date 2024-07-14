#!/bin/bash

usage() {
  echo "Usage: $0 [build|run]"
  exit 1
}

if [ $# -ne 1 ]; then
  usage
fi

set -a
source .env
set +a

case "$1" in
build)
  shell/nixpacks.sh
  docker build -f docker/dev.Dockerfile -t "$DOCKER_IMAGE":dev .
  ;;
push)
  docker push "$DOCKER_IMAGE" -a
  ;;
dev)
  docker compose -f docker/docker-compose.yaml -f docker/docker-compose.dev.yaml up
  ;;
prod)
  docker compose -f docker/docker-compose.yaml -f docker/docker-compose.prod.yaml up
  ;;
*)
  usage
  ;;
esac
