#! /bin/sh

cargo run -- \
    --target ../../README.md \
    --root ../.. \
    --levels 2 \
    --exclude vendor
