#!/bin/bash

if [ "$#" -lt 2 ] || [ "$2" != "cpu" -a "$2" != "gpu" ]; then
    echo "Usage: $0 [build|run] [cpu|gpu] [<data_dir>]"
    exit 1
fi

COMMAND="$1"
PLATFORM="$2"
TS=$(date +"%y_%m_%d")

if [ "$COMMAND" = "build" ]; then
    docker build \
        --progress=plain \
        --build-arg PLATFORM="$PLATFORM" \
        -t "$DOCKER_IMAGE:${PLATFORM}_latest" \
        -t "$DOCKER_IMAGE:${PLATFORM}_$TS" .
    docker push -a "$DOCKER_IMAGE"
elif [ "$COMMAND" = "run" ]; then
    if [ "$#" -ne 3 ]; then
        echo "Usage: $0 run [cpu|gpu] <data_dir>"
        exit 1
    fi
    DATA_DIR="$3"
    docker run --rm --network=host -v "$DATA_DIR:/data" "$DOCKER_IMAGE:${PLATFORM}_latest"
else
    echo "Unknown command: $COMMAND"
    echo "Usage: $0 [build|run] [cpu|gpu] [<data_dir>]"
    exit 1
fi
