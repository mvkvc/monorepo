#! /bin/bash

nbqa black nbs
nbqa isort nbs
nbqa pylint nbs
nbqa mypy nbs