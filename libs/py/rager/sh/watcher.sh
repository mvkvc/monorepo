#! /bin/sh

nbdev_export
mkdir -p ./watcher
rm -f ./watcher/*
python -m nuitka rager/watcher/app.py \
    --output-dir=./watcher \
    --output-filename=./watcher/watcher
