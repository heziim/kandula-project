#!/bin/bash

tee /etc/consul.d/grafana-server-3000.json > /dev/null <<"EOF"
{
  "service": {
    "id": "grafana-server-3000",
    "name": "grafana",
    "tags": ["monitoring"],
    "port": 3000,
    "checks": [
      {
        "id": "tcp",
        "name": "TCP on port 3000",
        "tcp": "localhost:3000",
        "interval": "10s",
        "timeout": "1s"
      },
      {
        "id": "http",
        "name": "HTTP on port 3000",
        "http": "http://localhost:3000/",
        "interval": "30s",
        "timeout": "1s"
      }
    ]
  }
}
EOF

consul reload
