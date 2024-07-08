#! /bin/bash

FILE="$HOME"/.config/exboost/desktop.log

if [ "$1" != "-f" ] && [ -n "$1" ]; then
    echo "Usage: $0 [-f]"
    exit 1
fi

if [ "$1" == "-f" ]; then
    true >"$FILE"
fi

codium "$FILE"
