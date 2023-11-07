#! /bin/bash

(
    cd lend_look
    ruff check .
    mypy .
    black --check .
    python manage.py lintmigrations
)
