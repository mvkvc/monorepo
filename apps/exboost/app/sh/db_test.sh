POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=exboost_test
DB_CONTAINER=db_exboost_test
DB_IMAGE=ankane/pgvector
DB_PORT=${DB_PORT:-5432}

if docker ps -a | grep -w $DB_CONTAINER; then docker kill $DB_CONTAINER; fi

docker run --rm --name $DB_CONTAINER -d \
  -p "$DB_PORT":5432 \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DB \
  -v $(pwd)/.db/data_test:/var/lib/postgresql/data \
  $DB_IMAGE
