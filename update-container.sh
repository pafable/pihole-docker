#!/usr/bin/env bash

DCKR=$(which docker)
DCKRCMP=$(which docker-compose)
IMAGE="pihole/pihole:latest"

function main() {
  echo "Shutting down pihole container"
  ${DCKRCMP} down

  echo "Pulling down latest pihole image"
  ${DCKR} pull ${IMAGE}

  echo "Starting new pihole container"
  ${DCKRCMP} up -d

  echo "Displaying new pihole container logs"
  ${DCKRCMP} logs

  echo "Deleting previous pihole image"
  ${DCKR} image prune
}

if [ "$(${DCKR} "ps" | grep -c -i "pihole")" == 1 ]
then
  main
fi