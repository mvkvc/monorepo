#! /bin/bash

DIR=./lend_look

black $DIR
npx prettier --write $DIR/static $DIR/*/templates
