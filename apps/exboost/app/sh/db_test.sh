#! /bin/sh

ENGINE=podman

POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=exboost_test
DB_CONTAINER=exboost_db_test
DB_IMAGE=docker.io/ankane/pgvector
DB_PORT=${DB_PORT:-5432}
DB_PATH=$(pwd)/.db/data_test

mkdir -p $DB_PATH

if $ENGINE ps -a | grep -w $DB_CONTAINER; then $ENGINE kill $DB_CONTAINER; fi

$ENGINE run --rm --name $DB_CONTAINER \
  -p "$DB_PORT":5432 \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DB \
  -v $DB_PATH:/var/lib/postgresql/data \
  $DB_IMAGE
