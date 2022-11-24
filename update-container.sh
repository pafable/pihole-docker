#!/usr/bin/env bash

DCKR=$(which docker)
DCKRCMP=$(which docker-compose)
IMAGE="pihole/pihole:latest"

function main() {
  printf "Shutting down pihole container\n"
  ${DCKRCMP} down

  printf "\nPulling down latest pihole image\n"
  ${DCKR} pull ${IMAGE}

  printf "\nStarting new pihole container\n"
  ${DCKRCMP} up -d

  printf "\nDisplaying new pihole container logs\n"
  ${DCKRCMP} logs

  printf "\nDeleting previous pihole image\n"
  ${DCKR} image prune --force
}

if [ "$(${DCKR} ps | grep -c -i "pihole")" == 1 ]
then
  main
fi
