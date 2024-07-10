#! /bin/sh

set -e

fly ssh console --pty --select -C "/app/bin/exboost remote"
