## Description

Docker E2E tests can be used along with the [Integration Test Environment](IntegrationEnvironments.md).

The tests build all services as `Docker` containers and check if their interaction works properly.

## Dependencies

- `Docker`
- `docker-compose`

## Command description

- `make e2e-build`

Builds all services as `Docker` containers

- `make e2e-run`

Runs all services using `docker-compose`

- `make e2e-test`

Runs integration tests using `Docker SDK` that check if interaction between containers works properly.

- `make e2e-stop`

Stops all services running in `Docker`

- `make e2e-clean`

Stops and Cleans up all images built by `make e2e-build`

## How to use

1. Build services with `make e2e-build`
2. Run services with `make e2e-run`
3. Run integration tests with `make e2e-test`
4. Stop services with `make e2e-stop`
5. Clean up created images with `make e2e-clean` 
