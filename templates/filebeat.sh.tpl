#!/bin/bash

wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-7.11.0-amd64.deb
dpkg -i filebeat-*.deb

sudo mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.BCK

cat <<\EOF > /etc/filebeat/filebeat.yml
filebeat.inputs:
  - type: log
    enabled: false
    paths:
      - /var/log/auth.log
filebeat.modules:
  - module: system
    syslog:
      enabled: true
    auth:
      enabled: true
filebeat.config.modules:
  reload.enabled: false
setup.dashboards.enabled: false
setup.template.name: "filebeat"
setup.template.pattern: "filebeat-*"
setup.template.settings:
  index.number_of_shards: 1
processors:
  - add_host_metadata:
      when.not.contains.tags: forwarded
  - add_cloud_metadata: ~
output.elasticsearch:
  hosts: [ "elasticsearch.service.consul:9200" ] # Elasticsearch REST interface
EOF

sudo systemctl start filebeat
