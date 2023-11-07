#! /bin/sh

export PYTHONPATH="$PYTHONPATH":"$(pwd)"
poetry run mkdocs serve
