POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=exboost_dev
DB_CONTAINER=exboost_db
DB_IMAGE=ankane/pgvector
DB_PORT=${DB_PORT:-5432}

if docker ps -a | grep -w $DB_CONTAINER; then docker stop $DB_CONTAINER; fi

docker run --rm --name $DB_CONTAINER  \
  -p "$DB_PORT":5432 \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DB \
  -v $(pwd)/.db/data:/var/lib/postgresql/data \
  $DB_IMAGE
