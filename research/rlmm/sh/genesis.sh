#!/bin/bash

set -a
source .env
set +a

# The base URL for the Genesis Cloud API
BASE_URL="https://api.genesiscloud.com/compute/v1/instances"

usage() {
  echo "Usage: $0 [status|start|stop] [cpu1|cpu2|gpu1]"
}

check_args() {
  if [ $# -lt 1 ]; then
    usage
    exit 1
  fi

  case "$1" in
  "status" | "start" | "stop") ;;
  *)
    usage
    exit 1
  ;;
  esac

  if [ $1 != "status" ] && [ $# -ne 2 ]; then
    usage
    exit 1
  fi

  if [ $# -eq 2 ]; then
    case "$2" in
    "cpu1" | "cpu2" | "gpu1") ;;
    *)
      usage
      exit 1
    ;;
    esac
  fi
}

set_instance() {
  case "$1" in
  "cpu1") GENESIS_INSTANCE="${GENESIS_CPU1}" ;;
  "cpu2") GENESIS_INSTANCE="${GENESIS_CPU2}" ;;
  "gpu") GENESIS_INSTANCE="${GENESIS_GPU}" ;;
  *) GENESIS_INSTANCE="${GENESIS_CPU1}" ;;
  esac
}

request_status() {
  local endpoint="$BASE_URL"
  [ $# -eq 1 ] && endpoint="${endpoint}/${GENESIS_INSTANCE}"
  curl -sH "X-Auth-Token: ${GENESIS_API_KEY}" $endpoint | jq '.instances[] | {name, type, status, volumes: [.volumes[].name]}'
}

send_action() {
  local action=$1
  curl -sH "X-Auth-Token: ${GENESIS_API_KEY}" \
    -X POST "${BASE_URL}/${GENESIS_INSTANCE}/actions" \
    -H "Content-Type: application/json" \
    --data-raw '{
        "action": "'$action'"
      }'
  request_status
}

check_args "$@"
set_instance "$2"

case "$1" in
"status")
  request_status
  ;;
"start")
  send_action "start"
  ;;
"stop")
  send_action "stop"
  ;;
*)
  usage
  ;;
esac
 