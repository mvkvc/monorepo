#!/bin/bash

set +a
source .env
set -a

usage() {
    echo "Usage: $0 [create|start|stop|restart|destroy|status]"
    exit 1
}

if [ $# -eq 0 ] || [ $# -gt 1 ]; then
    usage
fi

NAME="lend_look_db"

case "$1" in
create)
    docker run -d \
        --name $NAME \
        -p "$LOCAL_PG_PORT":5432 \
        -e POSTGRES_USER="$LOCAL_PG_USER" \
        -e POSTGRES_PASSWORD="$LOCAL_PG_PASS" \
        postgres:alpine
    ;;
start)
    docker start $NAME
    ;;
stop)
    docker stop $NAME
    ;;
restart)
    docker restart $NAME
    ;;
destroy)
    docker rm $NAME
    ;;
status)
    docker ps -a | grep $NAME
    ;;
*)
    usage
    ;;
esac
