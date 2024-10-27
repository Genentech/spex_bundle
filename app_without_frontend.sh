#!/usr/bin/env bash

###
# This file for development proposes.

alert="
IMPORTANT:
don't forget to set environment variables HOST_DATA_STORAGE
(it should be a path on your local machine)

The script awaits that you will do it in the ./set_env.local file
content of file for example:
$ cat ./set_env.local
export HOST_DATA_STORAGE=/home/user/data
"

source ./set_env.local || (
    echo "ERROR: set_env.local not found"
)

if [ -z "$HOST_DATA_STORAGE" ]; then
    echo "$alert"
    exit 1
fi

chmod +x ./common/build.sh

case "$1" in
    "build")
        echo "Building and up..."
        ./common/build.sh
        docker-compose -f ./docker-compose-without-frontend.yml up -d --build
        ;;
    "up")
        echo "Up..."
        ./common/build.sh
        docker-compose -f ./docker-compose-without-frontend.yml up -d
        ;;
    "down")
        echo "Down..."
        docker-compose -f ./docker-compose-without-frontend.yml down
        ;;
    "stop")
        echo "Stopping..."
        docker-compose -f ./docker-compose-without-frontend.yml stop
        ;;
    "start")
        echo "Starting..."
        docker-compose -f ./docker-compose-without-frontend.yml start
        ;;
    "rm")
        echo "Removing..."
        docker-compose rm -f -s -v
        ;;

    "run")
        echo "Running..."
        ./common/build.sh
        docker-compose -f ./docker-compose-without-frontend.yml run --rm $2 $3
        ;;
    *)
        echo "Usage: ./${0##*/} {build|up|down|stop|start|rm}"
        echo "
build - Builds the frontend, the docker images and up the microservices
up - up the microservices (similar: docker-compose up -d)
down - down the microservices (similar: docker-compose down)
stop - stop the microservices (similar: docker-compose stop)
start - start the microservices (similar: docker-compose start)
rm - remove the microservices (similar: docker-compose rm -f -s -v)
"
        ;;
esac
