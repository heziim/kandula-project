#!/bin/bash

tee /etc/consul.d/kibana-server-5601.json > /dev/null <<"EOF"

{
  "services": [
    {
    "id": "kibana-server-5601",
    "name": "kibana",
    "tags": ["elk"],
    "port": 5601,
    "checks": [
      {
        "id": "tcp",
        "name": "TCP on port 5601",
        "tcp": "localhost:5601",
        "interval": "10s",
        "timeout": "1s"
      },
      {
        "id": "http",
        "name": "HTTP on port 5601",
        "http": "http://localhost:5601/",
        "interval": "30s",
        "timeout": "1s"
      }
    ]
    },
    {
    "id": "elastic-rest-9200",
    "name": "elasticsearch",
    "tags": ["elk"],
    "port": 9200,
    "checks": [
      {
        "id": "tcp",
        "name": "TCP on port 9200",
        "tcp": "localhost:9200",
        "interval": "10s",
        "timeout": "1s"
      }
    ]
    }
  ]
}
EOF

consul reload
