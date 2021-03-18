#!/bin/bash

tee /etc/consul.d/prometheus-server-9090.json > /dev/null <<"EOF"

{
  "service": {
    "id": "prometheus-server-9090",
    "name": "prometheus",
    "tags": ["monitoring"],
    "port": 9090,
    "checks": [
      {
        "id": "tcp",
        "name": "TCP on port 9090",
        "tcp": "localhost:9090",
        "interval": "10s",
        "timeout": "1s"
      },
      {
        "id": "http",
        "name": "HTTP on port 9090",
        "http": "http://localhost:9090/",
        "interval": "30s",
        "timeout": "1s"
      }
    ]
    }
}
EOF

consul reload
