# CI_CD scripts

## Scripts

```sh
./ci_scripts                                
├── go_mod_replace.sh             # 
├── install-docker-compose.sh     #  Installation of docker-compose
├── install-golangci-lint.sh      #  Installation of linters
└── vendor-integration-check.sh   #  Check compatibility of master@skywire-services with last versions of vendored packages
```

## vendor-integration-check.sh

### Goal

Check compatibility of master@skywire-services with last versions of vendored packages 
including `skycoin/skywire` and `skycoin/dmsg`.
Used by travis-ci as part of cicd-pipeline in `skywire` and `dmsg` repositories.
Can be used directly with `make vendor-integration-check`

### Algorithm

1. `git clone` of master@skywire-services  - note that all tests are not on current branch but master
2. Fetch last versions of vendored packages
3. Build
4. Run regular tests
5. Run e2e tests

### Environment variables

#### GITHUB_TOKEN

Open https://github.com/settings/tokens
Press "Generate new token" button.
Create new token with checked scope "repo" (all group).

Use as environment variable, e.g:

```bash
$ export GITHUB_TOKEN=[your token]
```
or
```bash
$ GITHUB_TOKEN=[your token] make vendor-integration-check
```
