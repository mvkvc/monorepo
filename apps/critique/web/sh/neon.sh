#!/bin/bash

function start() {
    curl --request POST \
         --url https://console.neon.tech/api/v2/projects/"${NEON_PROJECT_ID}"/endpoints/"${NEON_ENDPOINT_ID}"/start \
         --header 'accept: application/json' \
         --header "authorization: Bearer ${NEON_API_KEY}"
}

function stop() {
    curl --request POST \
         --url https://console.neon.tech/api/v2/projects/"${NEON_PROJECT_ID}"/endpoints/"${NEON_ENDPOINT_ID}"/suspend \
         --header 'accept: application/json' \
         --header "authorization: Bearer ${NEON_API_KEY}"
}

function status() {
    curl --request GET \
     --url https://console.neon.tech/api/v2/projects/"${NEON_PROJECT_ID}"/endpoints/"${NEON_ENDPOINT_ID}" \
     --header 'accept: application/json' \
     --header "authorization: Bearer ${NEON_API_KEY}"
}


function usage() {
    echo "Usage: $0 [start|stop|status]"
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

case $1 in
start)
    start
    ;;
stop)
    stop
    ;;
status)
    status
    ;;
*)
    usage
    exit 1
    ;;
esac
