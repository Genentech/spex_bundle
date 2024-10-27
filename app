#!/usr/bin/env bash

build() {
  pushd ./frontend || exit 2

  yarn install
  NODE_OPTIONS="--max-old-space-size=4096" yarn build

  chmod -R o+rX ./build

  popd || exit 3
}

chmod -R 754 ./redis
chmod +x ./common/build.sh

export HOST_DATA_STORAGE=/mnt/storage

case "$1" in
    "build")
        echo "Building and up..."
        build
        ./common/build.sh
        docker-compose up -d --build
        ;;
    "build-frontend")
        echo "Building frontend only..."
        build
        ;;
    "up")
        echo "Up..."
        ./common/build.sh
        docker-compose up -d
        ;;
    "down")
        echo "Down..."
        docker-compose down
        ;;
    "stop")
        echo "Stopping..."
        docker-compose stop
        ;;
    "start")
        echo "Starting..."
        docker-compose start
        ;;
    "rm")
        echo "Removing..."
        docker-compose rm -f -s -v
        ;;
    *)
        echo "Usage: ./${0##*/} {build|build-frontend|up|down|stop|start|rm}"
        echo "
build - Builds the frontend, the docker images and up the microservices
build-frontend - Builds only the frontend
up - up the microservices (similar: docker-compose up -d)
down - down the microservices (similar: docker-compose down)
stop - stop the microservices (similar: docker-compose stop)
start - start the microservices (similar: docker-compose start)
rm - remove the microservices (similar: docker-compose rm -f -s -v)
"
        ;;
esac
