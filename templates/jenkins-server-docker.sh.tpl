#! /bin/bash
sudo apt-get update -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
mkdir -p /home/ubuntu/jenkins_home
sudo chown -R 1000:1000 /home/ubuntu/jenkins_home
sudo docker run -d --restart=always -p 8080:8080 -p 50000:50000 -v ${jenkins_home_mount} -v ${docker_sock_mount} --env ${java_opts} jenkins/jenkins

