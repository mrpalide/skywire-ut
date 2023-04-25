ARG image_tag
ARG base_image

FROM ${base_image} as builder

ARG build_opts

COPY . /skywire-services
WORKDIR /skywire-services

RUN go build "${build_opts}" -o /release/config-bootstrapper \
    ./cmd/config-bootstrapper && \ 
    mv /skywire-services/docker/config/config.json /release/config.json


FROM alpine as prod
COPY --from=builder /release/config-bootstrapper /release/config-bootstrapper
ENTRYPOINT ["/release/config-bootstrapper"]

FROM prod as test

# OS image
FROM alpine as e2e

COPY ./docker/common/install-prequisites.sh /release/install-prequisites.sh
RUN sh -c /release/install-prequisites.sh cert-only \
    && rm -rf /release/install-prequisites.sh

COPY --from=builder /release/config-bootstrapper /release/config-bootstrapper
COPY --from=builder /release/config.json /release/config.json
ENTRYPOINT ["/release/config-bootstrapper"]

FROM e2e as integration

FROM ${image_tag}
