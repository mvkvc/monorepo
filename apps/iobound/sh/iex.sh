#! /bin/sh

set -e

fly ssh console --pty --select -C "/app/bin/iobound remote"
