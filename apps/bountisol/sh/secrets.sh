#! /bin/bash

doppler secrets download \
    --project app \
    --config dev \
    --format env \
    --no-file \
    > .env
