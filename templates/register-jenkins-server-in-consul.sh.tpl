#!/bin/bash

tee /etc/consul.d/jenkins-server-8080.json > /dev/null <<"EOF"
{
  "service": {
    "id": "jenkins-server-8080",
    "name": "jenkins-server",
    "tags": ["jenkins"],
    "port": 8080,
    "checks": [
      {
        "id": "tcp",
        "name": "TCP on port 8080",
        "tcp": "localhost:8080",
        "interval": "10s",
        "timeout": "1s"
      },
      {
        "id": "http",
        "name": "HTTP on port 8080",
        "http": "http://localhost:8080/",
        "interval": "30s",
        "timeout": "1s"
      }
    ]
  }
}
EOF

consul reload
