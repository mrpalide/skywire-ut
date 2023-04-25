#! /usr/bin/env bash
export GO111MODULE=on
export COMPOSE_FILE=./docker/docker-compose.yml
set -e -x

# Clone from master
rm -rf /tmp/skywire-services &> /dev/null
cd /tmp
git clone https://"$GITHUB_TOKEN":x-oauth-basic@github.com/SkycoinPro/skywire-services.git --depth 1 --branch master
# git clone git@github.com:SkycoinPro/skywire-services.git --depth 1
cd skywire-services

# Checking build 
make dep
make build

# Running regular tests
make test

# Checking e2e-build
make e2e-clean
make e2e-build
make e2e-run

# Running e2e tests
make e2e-test
