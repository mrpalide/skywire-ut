
# Skywire Uptime Tracker

`skywire-ut` contains the uptime tracker, required for uptime-based rewards for `skywire-visor`.

- Uptime Tracker (UT)

## Running the services locally

Run `make build` to build the service and `make install` to install into go binaries folder.

Refer to the [`cmd`](cmd) subdirectories for setting up the individual service locally.

## Deployments

We run two service deployments - production and test.

Upon a push to `master` new code is deployed to prod on skywire.skycoin.com subomains

Pushing to `develop` deploys changes to test on skywire.dev subdomains.

Logs can be retrieved through `kubectl` or grafana.skycoin.com.

Check the [docs](docs/Deployments.md) for more documentation on the deployments. Check [Skywire Devops](https://github.com/SkycoinPro/skywire-devops) for more in depth info on our deployment setup.

## Documentation

- [Interactive Test Environment](docs/InteractiveEnvironments.md)
- [Docker Test Environment](docs/DockerEnvironment.md)
- [Load Testing](docs/LoadTesting.md)
- [Packages](docs/Packages.md)

## API Documentation

- [Uptime Tracker](cmd/uptime-tracker/README.md)
