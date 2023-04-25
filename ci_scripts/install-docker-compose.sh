#!/usr/bin/env bash

echo Installing docker-compose  v"$DOCKER_COMPOSE_VERSION"

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
curl -L https://github.com/docker/compose/releases/download/"${DOCKER_COMPOSE_VERSION}"/docker-compose-"$(uname -s)"-"$(uname -m)" > "$SOURCE_DIR"/../docker-compose

chmod +x "$SOURCE_DIR"/../docker-compose
