#!/usr/bin/env bash

DCKR=$(which docker)
DCKRCMP=$(which docker-compose)
IMAGE="pihole/pihole:latest"

function main() {
  printf "Shutting down pihole container"
  ${DCKRCMP} down

  printf "\nPulling down latest pihole image"
  ${DCKR} pull ${IMAGE}

  printf "\nStarting new pihole container"
  ${DCKRCMP} up -d

  printf "\nDisplaying new pihole container logs"
  ${DCKRCMP} logs

  printf "\nDeleting previous pihole image"
  ${DCKR} image prune
}

if [ "$(${DCKR} ps | grep -c -i "pihole")" == 1 ]
then
  main
fi
