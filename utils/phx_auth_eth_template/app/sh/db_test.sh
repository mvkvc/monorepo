export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=postgres
export POSTGRES_DB=akashi_test
export CONTAINER=db_akashi_test
export IMAGE=ankane/pgvector

if docker ps -a | grep -w $CONTAINER; then docker kill $CONTAINER; fi

docker run --rm --name $CONTAINER -p 5432:5432 \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DB \
  -v $(pwd)/.db/test:/var/lib/postgresql/data \
  $IMAGE
