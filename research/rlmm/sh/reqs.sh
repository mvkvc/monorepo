#!/bin/bash

poetry lock --no-update
poetry export -f requirements.txt \
    --without=gpu \
    --output requirements_no_gpu.txt
