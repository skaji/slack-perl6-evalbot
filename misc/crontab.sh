#!/bin/bash

set -eu

logger() {
  echo "[$(date)] $@"
}

cd "$(dirname "$0")"/..

LOGFILE=evalbot.log.$(date +%Y%m%d)
SLACK_TOKEN=$(cat SLACK_TOKEN)

exec >>$LOGFILE
exec 2>&1

if [[ -z $SLACK_TOKEN ]]; then
  logger "Missing SLACK_TOKEN file"
  exit 1
fi

logger "Start docker build"
docker build -t evalbot --no-cache=true .

EXISTING=$(docker ps  | perl -anle '/slack-soozy/ and print $F[0]')
if [[ -n $EXISTING ]]; then
  logger "docker stop existing docker process $EXISTING"
  docker stop $EXISTING
  docker rm slack-soozy
fi

docker run \
  --name slack-soozy \
  -e SLACK_TOKEN=$SLACK_TOKEN \
  -e SLACK_CHANNEL=perl6 \
  -d evalbot
