#!/bin/bash
set -e

sleep 10

echo "INFO: Installing elasticsearch, kibana"

# elasticsearch
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-7.10.2-amd64.deb
dpkg -i elasticsearch-*.deb
echo 'network.host: 0.0.0.0' > /etc/elasticsearch/elasticsearch.yml
echo 'discovery.type: single-node' >> /etc/elasticsearch/elasticsearch.yml
echo 'path.data: /var/lib/elasticsearch' >> /etc/elasticsearch/elasticsearch.yml
echo 'path.logs: /var/log/elasticsearch' >> /etc/elasticsearch/elasticsearch.yml
systemctl enable elasticsearch
systemctl start elasticsearch

# kibana
wget https://artifacts.elastic.co/downloads/kibana/kibana-oss-7.10.2-amd64.deb
dpkg -i kibana-*.deb
echo 'server.host: "0.0.0.0"' > /etc/kibana/kibana.yml
systemctl enable kibana
systemctl start kibana

echo "INFO: Finish installing elasticsearch, kibana"
