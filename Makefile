.DEFAULT_GOAL := help
.PHONY : check lint lint-extra install-linters dep test
.PHONY : build  clean install  format  build-race deploy

SHELL := /usr/bin/env bash

VERSION := $(shell git describe --always)

RFC_3339 := "+%Y-%m-%dT%H:%M:%SZ"
DATE := $(shell date -u $(RFC_3339))
COMMIT := $(shell git rev-list -1 HEAD)

OPTS?=GO111MODULE=on
DOCKER_OPTS?=GO111MODULE=on GOOS=linux # go options for compiling for docker container
DOCKER_NETWORK?=SKYWIRE
DOCKER_COMPOSE_FILE:=./docker/docker-compose.yml
DOCKER_REGISTRY:=skycoin
TEST_OPTS:=-tags no_ci -cover -timeout=5m
RACE_FLAG:=-race
GOARCH:=$(shell go env GOARCH)

ifneq (,$(findstring 64,$(GOARCH)))
    TEST_OPTS:=$(TEST_OPTS) $(RACE_FLAG)
endif

PROJECT_BASE := github.com/skycoin/skywire-ut
SKYWIRE_UTILITIES_REPO := github.com/skycoin/skywire-utilities
BUILDINFO_PATH := $(SKYWIRE_UTILITIES_REPO)/pkg/buildinfo

BUILDINFO_VERSION := -X $(BUILDINFO_PATH).version=$(VERSION)
BUILDINFO_DATE := -X $(BUILDINFO_PATH).date=$(DATE)
BUILDINFO_COMMIT := -X $(BUILDINFO_PATH).commit=$(COMMIT)

BUILDINFO?=$(BUILDINFO_VERSION) $(BUILDINFO_DATE) $(BUILDINFO_COMMIT)

BUILD_OPTS?="-ldflags=$(BUILDINFO)"
BUILD_OPTS_DEPLOY?="-ldflags=$(BUILDINFO) -w -s"

export COMPOSE_FILE=${DOCKER_COMPOSE_FILE}
export REGISTRY=${DOCKER_REGISTRY}

## : ## _ [Prepare code]

dep: ## Sorts dependencies
#	GO111MODULE=on GOPRIVATE=github.com/skycoin/* go get -v github.com/skycoin/skywire@master
	GO111MODULE=on GOPRIVATE=github.com/skycoin/* go mod vendor -v
	yarn --cwd ./pkg/node-visualizer/web install

format: dep ## Formats the code. Must have goimports and goimports-reviser installed (use make install-linters).
	goimports -w -local github.com/skycoin/skywire-ut ./pkg
	goimports -w -local github.com/skycoin/skywire-ut ./cmd
	goimports -w -local github.com/skycoin/skywire-ut ./internal
	find . -type f -name '*.go' -not -path "./vendor/*" -exec goimports-reviser -project-name ${PROJECT_BASE} -file-path {} \;

## : ## _ [Build, install, clean]

build: dep ## Build binaries
	${OPTS} go build ${BUILD_OPTS} -o ./bin/uptime-tracker ./cmd/uptime-tracker

build-deploy: ## Build for deployment Docker images
	go build ${BUILD_OPTS_DEPLOY} -mod=vendor -o /release/uptime-tracker ./cmd/uptime-tracker

build-race: dep ## Build binaries
	${OPTS} go build ${BUILD_OPTS} -race -o ./bin/uptime-tracker ./cmd/uptime-tracker

install: ## Install route-finder, transport-discovery, address-resolver, sw-env, keys-gen, uptime-tracker, network-monitor, node-visualizer
	${OPTS} go install ${BUILD_OPTS} \
		./cmd/uptime-tracker \

clean: ## Clean compiled binaries
	rm -rf bin

## : ## _ [Test and lint]

install-linters: ## Install linters
	- VERSION=1.40.0 ./ci_scripts/install-golangci-lint.sh
	GOPRIVATE=github.com/skycoin/* go get -u github.com/FiloSottile/vendorcheck
	# For some reason this install method is not recommended, see https://github.com/golangci/golangci-lint#install
	# However, they suggest `curl ... | bash` which we should not do
	GOPRIVATE=github.com/skycoin/* go get -u github.com/golangci/golangci-lint/cmd/golangci-lint
	${OPTS} GOPRIVATE=github.com/skycoin/* go get -u github.com/incu6us/goimports-reviser

install-shellcheck: ## install shellcheck to current directory
	./ci_scripts/install-shellcheck.sh

lint: ## Run linters. Use make install-linters first.
	golangci-lint run -c .golangci.yml ./...
	go vet -all -mod=vendor ./...

lint-windows-appveyor: ## Run linters. Use make install-linters first.
	C:\Users\appveyor\go\bin\golangci-lint run -c .golangci.yml ./...
	# The govet version in golangci-lint is out of date and has spurious warnings, run it separately
	go vet -all -mod=vendor ./...

lint-extra: ## Run linters with extra checks.
	golangci-lint run --no-config --enable-all ./...
	go vet -all -mod=vendor ./...

test: ## Run tests for net
	-go clean -testcache
	go test ${TEST_OPTS} -mod=vendor ./internal/...
	go test ${TEST_OPTS} -mod=vendor ./pkg/...

check: lint test

docker-push-test:
	bash ./docker/docker_build.sh test ${BUILD_OPTS_DEPLOY}
	bash ./docker/docker_push.sh test

docker-push:
	bash ./docker/docker_build.sh prod ${BUILD_OPTS_DEPLOY}
	bash ./docker/docker_push.sh prod

## : ## _ [Other]

run-syslog: ## Run syslog-ng in docker. Logs are mounted under /tmp/syslog
	-mkdir -p /tmp/syslog
	-docker container rm syslog-ng -f
	docker run -d -p 514:514/udp  -v /tmp/syslog:/var/log  --name syslog-ng balabit/syslog-ng:latest

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$|^##.*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
