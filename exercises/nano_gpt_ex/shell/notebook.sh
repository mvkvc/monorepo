#!/bin/bash

if [ -d "py/.venv" ]; then
  echo "Virtual environment found. Starting Jupyter Lab..."
  source .env && cd py && poetry run jupyter lab --allow-root
else
  echo "No virtual environment found. Creating one..."
  (source .env && cd py && poetry install --with=dev)
fi
