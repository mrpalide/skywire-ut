#!/usr/bin/env bash

tag="$1"

# shellcheck disable=SC2153
registry="$REGISTRY"

if [ -z "$registry" ]; then
	registry="skycoin"
fi

if [ -z "$tag" ]; then
  echo "Image tag is not provided. Usage: sh ./docker/docker_push.sh <image_tag>"
  exit
fi

echo "Pushing to $registry using tag: $tag"

docker push "$registry"/"uptime-tracker":"$tag"
