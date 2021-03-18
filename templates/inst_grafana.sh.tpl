#!/bin/bash

set -e

cd /home/ubuntu
mkdir compose
mkdir compose/grafana

tee compose/docker-compose.yml > /dev/null <<"EOF"

version: "3.4"
x-logging:
  &default-logging
  options:
    max-size: '10m'
    max-file: '5'
  driver: json-file

services:
  grafana:
    image: grafana/grafana:7.4.3
    ports:
      - 3000:3000
    volumes:
#      - ./grafana/grafana.ini:/etc/grafana/grafana.ini
      - grafana_data:/var/lib/grafana
    restart: unless-stopped
    logging: *default-logging

volumes:
  grafana_data:

EOF

cd /home/ubuntu/compose
docker-compose down
docker-compose up -d
