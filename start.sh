#!/bin/bash

echo "Starting kong-database..."

docker-compose up -d kong-database

STATUS="starting"

while [ "$STATUS" != "healthy" ]
do
    STATUS=$(docker inspect --format {{.State.Health.Status}} kong-database)
    echo "kong-database state = $STATUS"
    sleep 5
done

docker-compose up -d proxy-database

STATUS_PROXY="starting"

while [ "$STATUS_PROXY" != "healthy" ]
do
    STATUS_PROXY=$(docker inspect --format {{.State.Health.Status}} proxy-database)
    echo "proxy-database state = $STATUS_PROXY"
    sleep 5
done

echo "Run database migrations..."

docker-compose up migrations


echo "Run database proxy-migrations..."

docker-compose up proxy-migrations

echo "Starting kong..."

docker-compose up -d kong1
docker-compose up -d kong2
docker-compose up -d proxy

#echo "Kong admin running http://127.0.0.1:8001/"

docker-compose up -d konga
