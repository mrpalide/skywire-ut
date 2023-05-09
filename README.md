
# Skywire Uptime Tracker

`skywire-ut` contains the uptime tracker, required for uptime-based rewards for `skywire-visor`.

- Uptime Tracker (UT)

## Running the services locally

Run `make build` to build the service and `make install` to install into go binaries folder.

Refer to the [`cmd`](cmd) subdirectories for setting up the individual service locally.

### DB Setup
`uptime-tracker` needs database for running that we use postgresql here as default database. For setting it up, you just need run pg (by docker or install binary or etc.), make a database with UTF-8 character-set, and pass two credential as flag and save three of them as env variable before running services.

First of all, you needs run postgres. You can run it by docker:
```
docker run --name skywire-ut-pg -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=skywire-ut -d postgres
```

then, if you want run `uptime-tracker` service, you should pass `--pg-host` and `--pg-port` as flag on running its binary, and also save `PG_USER`, `PG_PASSWORD` and `PG_DATABASE` as env variable.
```
export PG_USER=skywire-ut
export PG_PASSWORD=secret
export PG_DATABASE=skywire-ut
```
and run service by

```
./uptime-tracker --pg-host localhost --pg-port 5432
```

All tables created automatically and no need handle manually.

## Deployments

TPD

## API Documentation

- [Uptime Tracker](cmd/uptime-tracker/README.md)
