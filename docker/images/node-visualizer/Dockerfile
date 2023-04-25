ARG image_tag
ARG base_image

FROM node:16-alpine AS react-builder


COPY ./ /app
WORKDIR /app
RUN yarn --cwd ./pkg/node-visualizer/web install && \
		yarn --cwd ./pkg/node-visualizer/web build && \
		rm -rf ./pkg/node-visualizer/api/build/static && \
		mv ./pkg/node-visualizer/web/build/* ./pkg/node-visualizer/api/build


FROM ${base_image} as builder
ARG build_opts

# COPY . /skywire-services
COPY --from=react-builder ./app/ /skywire-services/
WORKDIR /skywire-services

RUN go build "${build_opts}" -o /release/node-visualizer ./cmd/node-visualizer

FROM alpine as prod
COPY --from=builder /release/node-visualizer /release/node-visualizer
ENTRYPOINT ["/release/node-visualizer"]

FROM prod as test

# OS image
FROM alpine as e2e
COPY ./docker/common/install-prequisites.sh /release/install-prequisites.sh
RUN sh -c /release/install-prequisites.sh cert-only \
    && rm -rf /release/install-prequisites.sh

COPY --from=builder /release/node-visualizer /release/node-visualizer
ENTRYPOINT ["/release/node-visualizer"]

FROM e2e as integration

FROM ${image_tag}
