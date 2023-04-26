#!/usr/bin/env bash

image_tag="$1"

if [ -z "$image_tag" ]; then
	image_tag=e2e
fi

declare -a images_arr=(
  "skycoin/uptime-tracker:${image_tag}"
)

for i in "${images_arr[@]}"; do
  docker rmi -f "$i"
done
