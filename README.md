
# Skywire Uptime Tracker

`skywire-ut` contains the uptime tracker, required for uptime-based rewards for `skywire-visor`.

- Uptime Tracker (UT)

## Running the services locally

Run `make build` to build the service and `make install` to install into go binaries folder.

Refer to the [`cmd`](cmd) subdirectories for setting up the individual service locally.

### DB Setup
`uptime-tracker` needs database for running that we use postgresql here as default database. For setting it up, you just need run pg (by docker or install binary or etc.), make a database with UTF-8 character-set, and pass two credential as flag and save three of them as env variable before running services.

First of all, you needs run postgres and redis. You can run it by docker:
```
docker run --name skywire-ut-pg -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=skywire-ut -p 5432:5432 -d postgres
docker run --name my-redis -p 6379:6379 -d redis
```

then, if you want run `uptime-tracker` service, you should pass `--pg-host` and `--pg-port` as flag on running its binary, and also save `PG_USER`, `PG_PASSWORD` and `PG_DATABASE` as env variable.
```
export PG_USER=skywire-ut
export PG_PASSWORD=secret
export PG_DATABASE=skywire-ut
```
and run it by

```
./bin/uptime-tracker --pg-host localhost --pg-port 5432 --store-data-path skywire-ut/daily-data
```

All tables created automatically and no need handle manually.

## Deployments

TPD

## API Documentation

- [Uptime Tracker](cmd/uptime-tracker/README.md)
