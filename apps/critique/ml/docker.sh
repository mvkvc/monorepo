#! /bin/bash

docker build -f ./Dockerfile -t mvkvc/critique:base .
(cd ./train && docker build --no-cache -f ./Dockerfile -t mvkvc/critique:train .)
(cd ./infer && docker build --no-cache -f ./Dockerfile -t mvkvc/critique:infer .)
docker push mvkvc/critique -a
