#!/bin/bash

set +a; source .env; set -a

if [ ! -d ".venv" ]; then
    python3 -m venv .venv
    source .venv/bin/activate
    pip install --upgrade pip
    pip install git+https://github.com/clockfort/GitHub-Backup
else
    source .venv/bin/activate
fi

github-backup --gists --starred-gists --starred "$GITHUB_USER" "$BACKUP_LOCATION"

deactivate
