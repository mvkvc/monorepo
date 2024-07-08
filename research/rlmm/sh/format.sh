#! /bin/bash

nbqa black nbs
nbqa isort nbs
nbdev_export
