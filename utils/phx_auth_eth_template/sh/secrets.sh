#! /bin/bash

(cd ./contracts &&
doppler secrets download \
    --project contracts \
    --config dev \
    --format env \
    --no-file \
    > .secret
)

(cd ./app &&
doppler secrets download \
    --project app \
    --config dev \
    --format env \
    --no-file \
    > .secret
)

(cd ./site &&
doppler secrets download \
    --project site \
    --config dev \
    --format env \
    --no-file \
    > .secret
)
