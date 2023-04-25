#!/usr/bin/env bash
trap "exit" INT

## Variables
image_tag="$1"
go_buildopts="$2"
git_branch="$(git rev-parse --abbrev-ref HEAD)"
nv_dev_url="https://nv.skywire.dev/map"
nv_prod_url="https://nv.skycoin.com/map"
nv_e2e_url="https://localhost:9081/map"
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

if [[ "$image_tag" == "e2e" ]]; then

  if [ "$DOCKER_USERNAME" != "" ] && [ "$DOCKER_PASSWORD" != "" ]; then
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
  fi

  # TODO(ersonp): instead of cloning the git branch we should directly use the docker image od SD from dockerhub like we doing for dmsg 
  if [[ "$GITHUB_TOKEN" != "" ]]; then
    git clone https://"$GITHUB_TOKEN":x-oauth-basic@github.com/SkycoinPro/skycoin-service-discovery --depth 1 --branch "$git_branch" ./tmp/skycoin-service-discovery
  else
    git clone git@github.com:SkycoinPro/skycoin-service-discovery --depth 1 --branch "$git_branch" ./tmp/skycoin-service-discovery
  fi

  if [ ! -d ./tmp/skycoin-service-discovery ]; then
    echo "failed to clone skycoin-service-discovery" &&
      exit 1
  fi

  echo ====================================================
  echo "BUILDING SKYWIRE VISOR"

  # TODO(ersonp): we should use the dockerimage for skywire-visor from dockerhub too
  DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/skywire-visor/Dockerfile \
    -t "$registry"/skywire-visor:"$image_tag" .

  echo ============ Base images ready ======================

  if [[ "$git_branch" == "master" ]]; then
    dockerhub_image_tag="prod"
  else
    dockerhub_image_tag="test"
  fi

  echo "build dmsg discovery image"
  DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/dmsg-discovery/Dockerfile \
    --build-arg build_opts="$go_buildopts" \
    --build-arg image_tag="$image_tag" \
    --build-arg base_image="skycoin/dmsg-discovery:$dockerhub_image_tag" \
    -t "$registry"/dmsg-discovery:"$image_tag" .

  echo "build dmsg server image"
  DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/dmsg-server/Dockerfile \
    --build-arg base_image="skycoin/dmsg-server:$dockerhub_image_tag" \
    --build-arg build_opts="$go_buildopts" \
    --build-arg image_tag="$image_tag" \
    -t "$registry"/dmsg-server:"$image_tag" .

  echo "build service discovery image"
  DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/service-discovery/Dockerfile \
    --build-arg base_image="$base_image" \
    --build-arg build_opts="$go_buildopts" \
    --build-arg image_tag="$image_tag" \
    -t "$registry"/service-discovery:"$image_tag" .

  rm -rf ./tmp/skycoin-service-discovery
fi

if [[ "$image_tag" == "integration" ]]; then
  # TODO(ersonp) : the binaries build in the images need to be built with the -race flag
  rm -rf ./tmp/skycoin-service-discovery
  rm -rf ./tmp/dmsg
  rm -rf ./tmp/skywire
  cp -r ../skycoin-service-discovery ./tmp
  cp -r ../dmsg ./tmp
  cp -r ../skywire ./tmp

  echo ====================================================
  echo "BUILDING SKYWIRE VISOR"

  DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/skywire-visor/DockerfileInt \
    -t "$registry"/skywire-visor:"$image_tag" .

  echo ============ Base images ready ======================

  echo "build dmsg discovery image"
  DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/dmsg-discovery/DockerfileInt \
    -t "$registry"/dmsg-discovery:"$image_tag" .

  echo "build dmsg server image"
  DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/dmsg-server/DockerfileInt \
    -t "$registry"/dmsg-server:"$image_tag" .

  echo "build service discovery image"
  DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/service-discovery/Dockerfile \
    --build-arg base_image="$base_image" \
    --build-arg build_opts="$go_buildopts" \
    --build-arg image_tag="$image_tag" \
    -t "$registry"/service-discovery:"$image_tag" .

  rm -rf ./tmp/*
fi

echo "Build transport discovery image"
DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/transport-discovery/Dockerfile \
  --build-arg base_image="$base_image" \
  --build-arg build_opts="$go_buildopts" \
  --build-arg image_tag="$image_tag" \
  -t "$registry"/transport-discovery:"$image_tag" .

echo "build route finder image"
DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/route-finder/Dockerfile \
  --build-arg base_image="$base_image" \
  --build-arg build_opts="$go_buildopts" \
  --build-arg image_tag="$image_tag" \
  -t "$registry"/route-finder:"$image_tag" .

echo "build setup node image"
DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/setup-node/Dockerfile \
  --build-arg base_image="$base_image" \
  --build-arg build_opts="$go_buildopts" \
  --build-arg image_tag="$image_tag" \
  -t "$registry"/setup-node:"$image_tag" .

echo "build address resolver image"
DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/address-resolver/Dockerfile \
  --build-arg build_opts="$go_buildopts" \
  --build-arg image_tag="$image_tag" \
  --build-arg base_image="$base_image" \
  -t "$registry"/address-resolver:"$image_tag" .

echo "build uptime tracker image"
DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/uptime-tracker/Dockerfile \
  --build-arg build_opts="$go_buildopts" \
  --build-arg image_tag="$image_tag" \
  --build-arg base_image="$base_image" \
  -t "$registry"/uptime-tracker:"$image_tag" .

if [[ "$image_tag" == "test" ]]; then
  echo "build node visualizer DEV image"
  echo "REACT_APP_SKY_NODEVIZ_URL=${nv_dev_url}" > ./pkg/node-visualizer/web/.env
elif [[ "$image_tag" == "prod" ]]; then
  echo "build node visualizer PROD image"
  echo "REACT_APP_SKY_NODEVIZ_URL=${nv_prod_url}" > ./pkg/node-visualizer/web/.env
elif [[ "$image_tag" == "e2e" ]]; then
  echo "build node visualizer E2E image"
  echo "REACT_APP_SKY_NODEVIZ_URL=${nv_e2e_url}" > ./pkg/node-visualizer/web/.env
elif [[ "$image_tag" == "integration" ]]; then
  echo "build node visualizer INTEGRATION image"
  echo "REACT_APP_SKY_NODEVIZ_URL=${nv_e2e_url}" > ./pkg/node-visualizer/web/.env
fi

DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/node-visualizer/Dockerfile \
  --build-arg base_image="$base_image" \
  --build-arg build_opts="$go_buildopts" \
  --build-arg image_tag="$image_tag" \
  -t "$registry"/node-visualizer:"$image_tag" .

echo "building network monitor image"
DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/network-monitor/Dockerfile \
  --build-arg base_image="$base_image" \
  --build-arg build_opts="$go_buildopts" \
  --build-arg image_tag="$image_tag" \
  -t "$registry"/network-monitor:"$image_tag" .

echo "building config bootstrapper image"
DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/config-bootstrapper/Dockerfile \
  --build-arg base_image="$base_image" \
  --build-arg build_opts="$go_buildopts" \
  --build-arg image_tag="$image_tag" \
  -t "$registry"/config-bootstrapper:"$image_tag" .

echo "building liveness checker image"
DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/liveness-checker/Dockerfile \
  --build-arg base_image="$base_image" \
  --build-arg build_opts="$go_buildopts" \
  --build-arg image_tag="$image_tag" \
  -t "$registry"/liveness-checker:"$image_tag" .

echo "building vpn monitor image"
DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/vpn-monitor/Dockerfile \
  --build-arg base_image="$base_image" \
  --build-arg build_opts="$go_buildopts" \
  --build-arg image_tag="$image_tag" \
  -t "$registry"/vpn-monitor:"$image_tag" .

echo "building public visor monitor image"
DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/public-visor-monitor/Dockerfile \
  --build-arg base_image="$base_image" \
  --build-arg build_opts="$go_buildopts" \
  --build-arg image_tag="$image_tag" \
  -t "$registry"/public-visor-monitor:"$image_tag" .

echo "building dmsg monitor image"
DOCKER_BUILDKIT="$bldkit" docker build -f docker/images/dmsg-monitor/Dockerfile \
  --build-arg base_image="$base_image" \
  --build-arg build_opts="$go_buildopts" \
  --build-arg image_tag="$image_tag" \
  -t "$registry"/dmsg-monitor:"$image_tag" .


wait

echo service images built
