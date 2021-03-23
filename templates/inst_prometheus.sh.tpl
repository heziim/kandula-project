#!/bin/bash

set -e

cd /home/ubuntu
mkdir compose
mkdir compose/prometheus

tee compose/prometheus/prometheus.yml > /dev/null <<"EOF"
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['localhost:9090']

  - job_name: 'prometheus_node_exporter'
    scrape_interval: 15s
    static_configs:
      - targets: 
        - '172.17.0.1:9100'

  - job_name: 'elk_node_exporter'
    scrape_interval: 15s
    static_configs:
      - targets:
        - 'elasticsearch.service.consul:9100'

  - job_name: 'jenkins_server_node_exporter'
    scrape_interval: 15s
    static_configs:
      - targets:
        - 'jenkins-server.service.consul:9100'

  - job_name: 'grafana_node_exporter'
    scrape_interval: 15s
    static_configs:
      - targets:
        - 'grafana.service.consul:9100'

  - job_name: 'kandula_app'
    consul_sd_configs:
    - server: 'consul.service.consul:8500'
      services:
        - 'lb-default'
    relabel_configs:
      - source_labels: ['__address__']
        target_label: '__address__'
        regex: '(.*):.*'
        replacement: $1:5001
      - source_labels: ['__meta_consul_tags']
        target_label: 'consul_tags_name'
      - source_labels: ['__meta_consul_dc']
        target_label: 'consul_dc_name'
EOF

tee compose/docker-compose.yml > /dev/null <<"EOF"

version: "3.4"
x-logging:
  &default-logging
  options:
    max-size: '10m'
    max-file: '5'
  driver: json-file

services:
  prometheus:
    image: prom/prometheus:v2.24.1
    ports:
     - 9090:9090
    volumes:
     - ./prometheus:/etc/prometheus
     - prometheus_data:/prometheus
    command: >
      --config.file=/etc/prometheus/prometheus.yml
      --storage.tsdb.path=/prometheus
      --storage.tsdb.retention=30d
#      --web.enable-admin-api
    restart: unless-stopped
    logging: *default-logging

volumes:
  prometheus_data:

EOF

cd /home/ubuntu/compose
docker-compose down
docker-compose up -d
