#!/usr/bin/env bash

image_tag="$1"

if [ -z "$image_tag" ]; then
	image_tag=e2e
fi

declare -a images_arr=(
  "skycoinpro/setup-node:${image_tag}"
  "skycoinpro/route-finder:${image_tag}"
  "skycoinpro/transport-discovery:${image_tag}"
  "skycoinpro/address-resolver:${image_tag}"
  "skycoinpro/dmsg-server:${image_tag}"
  "skycoinpro/dmsg-discovery:${image_tag}"
  "skycoinpro/uptime-tracker:${image_tag}"
  "skycoinpro/skywire-visor:${image_tag}"
  "skycoinpro/service-discovery:${image_tag}"
  "skycoinpro/network-monitor:${image_tag}"
  "skycoinpro/node-visualizer:${image_tag}"
  "skycoinpro/config-bootstrapper:${image_tag}"
  "skycoinpro/liveness-checker:${image_tag}"
  "skycoinpro/vpn-monitor:${image_tag}"
  "skycoinpro/public-visor-monitor:${image_tag}"
  "skycoinpro/dmsg-monitor:${image_tag}"
)

for i in "${images_arr[@]}"; do
  docker rmi -f "$i"
done
