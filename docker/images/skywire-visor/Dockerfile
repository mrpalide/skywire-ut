ARG image_tag=e2e

ARG base=alpine
FROM golang:alpine3.13 as builder

ARG BUILDINFO_LDFLAGS
ARG CGO_ENABLED=0
ENV CGO_ENABLED=${CGO_ENABLED} \
    GOOS=linux  \
    GO111MODULE=on

WORKDIR /

RUN apk add --no-cache make git build-base && \
    git clone https://github.com/skycoin/skywire && \
    cd skywire && git checkout develop && \
    sh -c /skywire/docker/images/visor/install-preq.sh && \
    make build-race && \
    mkdir -p /apps && \
    cp ./apps/vpn-server /apps/ && \
    cp ./apps/vpn-client /apps/ && \
	cp ./apps/skysocks /apps/ && \
	cp ./apps/skysocks-client /apps/ && \
	cp ./apps/skychat /apps/

## Resulting image
FROM ${base} as visor-runner

COPY --from=builder /skywire/docker/images/visor/install-preq.sh /release/install-preq.sh
COPY --from=builder /release /release
COPY --from=builder /apps /apps

RUN sh -c /release/install-preq.sh \
    && rm -rf /release/install-preq.sh \
    && mkdir -p /opt/skywire &&\
    apk add curl 

STOPSIGNAL SIGINT

ENTRYPOINT [ "/release/skywire-visor" ]

# default target
FROM visor-runner as prod

FROM visor-runner as test

FROM visor-runner as e2e

FROM ${image_tag}
