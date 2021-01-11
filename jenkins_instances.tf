#locals {
#  jenkins_home_mount = "/home/ubuntu/jenkins_home:/var/jenkins_home"
#  docker_sock_mount = "/var/run/docker.sock:/var/run/docker.sock"
#  java_opts = "JAVA_OPTS='-Djenkins.install.runSetupWizard=false'"
#}

data "template_file" "jenkins-server-docker" {
  template = file("templates/jenkins-server-docker.sh.tpl")
  vars = {
    jenkins_home_mount = "/home/ubuntu/jenkins_home:/var/jenkins_home"
    docker_sock_mount = "/var/run/docker.sock:/var/run/docker.sock"
    java_opts = "JAVA_OPTS='-Djenkins.install.runSetupWizard=false'"
  }

}

data "template_cloudinit_config" "docker-consul-agent" {
  gzip = false
  base64_encode = false
  part {
    content = data.template_file.consul_client.0.rendered
  }
  part {
    content = data.template_file.jenkins-server-docker.rendered
  }
}


resource "aws_instance" "jenkins_server" {
  # count = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  # subnet_id = module.vpc.public_subnets_ids[count.index]
  subnet_id = module.vpc.public_subnets_ids[0]
  key_name = aws_key_pair.kandula_key.key_name
  #depends_on = module.vpc.internet_gw
  vpc_security_group_ids = [aws_security_group.kandula_jenkins_server.id,aws_security_group.consul.id]
  iam_instance_profile   = aws_iam_instance_profile.consul-join2.name
  tags = {
    Name = "kandula-jenkins-server"
  }
  user_data = data.template_cloudinit_config.docker-consul-agent.rendered
#user_data = <<-EOF
#! /bin/bash
#sudo apt-get update -y
#sudo apt install docker.io -y
#sudo systemctl start docker
#sudo systemctl enable docker
#sudo usermod -aG docker ubuntu
#mkdir -p /home/ubuntu/jenkins_home
#sudo chown -R 1000:1000 /home/ubuntu/jenkins_home
#sudo docker run -d --restart=always -p 8080:8080 -p 50000:50000 -v ${local.jenkins_home_mount} -v ${local.docker_sock_mount} --env ${local.java_opts} jenkins/jenkins
#EOF
}


resource "aws_instance" "jenkins_agents" {
  count = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = module.vpc.private_subnets_ids[count.index]
  key_name = aws_key_pair.kandula_key.key_name
  vpc_security_group_ids = [aws_security_group.consul.id]
  iam_instance_profile   = aws_iam_instance_profile.admin-access.name
  depends_on = [module.vpc.igw,module.vpc.natgw]
  tags = {
    Name = "jenkins_agent${count.index}"
  }
  user_data = element(data.template_file.consul_client.*.rendered, count.index+1)
}
