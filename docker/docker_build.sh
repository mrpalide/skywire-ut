#!/usr/bin/env bash
trap "exit" INT

## Variables
image_tag="$1"
go_buildopts="$2"
git_branch="$(git rev-parse --abbrev-ref HEAD)"
bldkit="1"

# shellcheck disable=SC2153
registry="$REGISTRY"

# shellcheck disable=SC2153
base_image=golang:1.19-alpine

if [[ "$#" != 2 ]]; then
  echo "docker_build.sh <IMAGE_TAG> <GO_BUILDOPTS>"
fi

if [[ "$go_buildopts" == "" ]]; then
  go_buildopts="-mod=vendor -ldflags\"-w -s\""
fi

if [[ "$git_branch" != "master" ]] && [[ "$git_branch" != "develop" ]]; then
  git_branch="develop"
fi

echo "Building using tag: $image_tag"

echo "build uptime tracker image"
DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/uptime-tracker/Dockerfile \
  --build-arg build_opts="$go_buildopts" \
  --build-arg image_tag="$image_tag" \
  --build-arg base_image="$base_image" \
  -t "$registry"/uptime-tracker:"$image_tag" .

wait

echo service images built
