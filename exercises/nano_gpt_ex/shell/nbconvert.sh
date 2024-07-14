#! /bin/bash

path=$1
abs_path="$PWD/$path"

echo $abs_path

source .env && cd py && poetry run jupyter nbconvert --execute --inplace --to notebook "$abs_path"

