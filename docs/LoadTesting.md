## Load Testing

In order to run load testing on services you will need `tsung` installed, its config for the needed service and, probably, modified service to simplify testing procedure. For example, uptime tracker on `/update` endpoints requires authorization which can't be achieved with `tsung`, so we need to remove it for testing.

### Tsung Installation

To install `tsung` run the following commands:

```sh
$ apt update
$ apt install erlang
$ apt install gnuplot-nox libtemplate-perl libhtml-template-perl libhtml-template-expr-perl
$ wget http://tsung.erlang-projects.org/dist/tsung-1.7.0.tar.gz
$ tar -zxvf tsung-1.7.0 .tar.gz
$ cd ./tsung-1.7.0
$ ./configure && make && make install
$ mkdir $HOME/.tsung  
```

`tsung` is now installed on `172.105.122.153`.

### Running Tests

Uptime tracker is now ready for load testing. To enable it, you should pass `--enable-load-testing` flag to the binary.

To deploy services for load testing, run:

```sh
$ make docker-push-test
$ make deploy-load-testing
```

Then you should run `tsung` from the suitable machine. `172.105.122.153` may be used for this purposes. It's run this way:

```sh
$ tsung -f PATH_TO_CONFIG start
```

Config files are located in `skywire-services/load-testing/`.

The tests logically consist of two phases which are executed in parallel. First, `tsung` creates clients and then generates requests from these clients. Anytime test can be interrupted with Ctrl-C to save the results.

After test is aborted, `cd` into the directory where `tsung` put logs for this test. This directory is outputted at the beginning of the test. From there run:

```sh
$ /usr/lib/tsung/bin/tsung_stats.pl
```

After that you may `zip` this folder, download it to your machine, unpack and open `graph.html` to views the results.