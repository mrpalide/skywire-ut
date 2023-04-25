ARG image_tag
ARG base_image

FROM ${base_image} as builder

ARG build_opts

COPY . /skywire-services
WORKDIR /skywire-services

RUN go build "${build_opts}" -o /release/dmsg-monitor ./cmd/dmsg-monitor && \
    mv /skywire-services/docker/config/dmsg-monitor.json /release/dmsg-monitor.json

FROM alpine as prod
COPY --from=builder /release/dmsg-monitor /release/dmsg-monitor
COPY --from=builder /release/dmsg-monitor.json /release/dmsg-monitor.json
ENTRYPOINT ["/release/dmsg-monitor"]

FROM prod as test

# OS image
FROM alpine as e2e
WORKDIR /release

COPY ./docker/common/install-prequisites.sh /release/install-prequisites.sh
RUN sh -c /release/install-prequisites.sh cert-only \
    && rm -rf /release/install-prequisites.sh

COPY --from=builder /release/dmsg-monitor /release/dmsg-monitor
COPY --from=builder /release/dmsg-monitor.json /release/dmsg-monitor.json
ENTRYPOINT ["/release/dmsg-monitor"]

FROM e2e as integration

FROM ${image_tag}
