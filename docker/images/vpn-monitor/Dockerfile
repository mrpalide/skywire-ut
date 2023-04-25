ARG image_tag
ARG base_image

FROM ${base_image} as builder

ARG build_opts

COPY . /skywire-services
WORKDIR /skywire-services

RUN go build "${build_opts}" -o /release/vpn-monitor ./cmd/vpn-monitor && \
    go build "${build_opts}" -o /release/vpn-client ./cmd/vpn-lite-client

FROM alpine as prod
COPY --from=builder /release/vpn-client /apps/vpn-client
COPY --from=builder /release/vpn-monitor /release/vpn-monitor
ENTRYPOINT ["/release/vpn-monitor"]

FROM prod as test

# OS image
FROM alpine as e2e
WORKDIR /release

COPY ./docker/common/install-prequisites.sh /release/install-prequisites.sh
RUN sh -c /release/install-prequisites.sh cert-only \
    && rm -rf /release/install-prequisites.sh

COPY --from=builder /release/vpn-client /release/vpn-client
COPY --from=builder /release/vpn-monitor /release/vpn-monitor
ENTRYPOINT ["/release/vpn-monitor"]

FROM e2e as integration

FROM ${image_tag}
