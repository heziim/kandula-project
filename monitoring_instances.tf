resource "aws_instance" "grafana_server" {
  ami                           = data.aws_ami.ubuntu.id
  instance_type                 = "t2.micro"
  associate_public_ip_address   = true
  subnet_id                     = module.vpc.public_subnets_ids[1]
  key_name                      = aws_key_pair.kandula_key.key_name
  depends_on 			= [module.vpc.internet_gw]
  vpc_security_group_ids        = [aws_security_group.monitoring_server.id,aws_security_group.consul.id]
  iam_instance_profile          = aws_iam_instance_profile.consul-join2.name

  tags = {
    Name = "grafana server"
  }
  user_data = data.template_cloudinit_config.all-grafana-server.rendered
}

resource "aws_instance" "prometheus_server" {
  ami                           = data.aws_ami.ubuntu.id
  instance_type                 = "t2.micro"
  associate_public_ip_address   = true
  subnet_id                     = module.vpc.public_subnets_ids[1]
  key_name                      = aws_key_pair.kandula_key.key_name
  depends_on 			= [module.vpc.internet_gw]
  vpc_security_group_ids        = [aws_security_group.monitoring_server.id,aws_security_group.consul.id]
  iam_instance_profile          = aws_iam_instance_profile.consul-join2.name

  tags = {
    Name = "prometheus server"
  }
  user_data = data.template_cloudinit_config.all-prometheus-server.rendered
}


data "template_cloudinit_config" "all-prometheus-server" {
  gzip = false
  base64_encode = false
  part {
    content = data.template_file.consul_agent.rendered
  }
  part {
    content = data.template_file.filebeat.rendered
  }
  part {
    content = data.template_file.node-exporter.rendered
  }
  part {
    content = data.template_file.install_docker.rendered
  }
  part {
    content = data.template_file.install_prometheus.rendered
  }
  part {
    content = data.template_file.register-prometheus-server-in-consul.rendered
  }
}



data "template_cloudinit_config" "all-grafana-server" {
  gzip = false
  base64_encode = false
  part {
    content = data.template_file.consul_agent.rendered
  }
  part {
    content = data.template_file.filebeat.rendered
  }
  part {
    content = data.template_file.node-exporter.rendered
  }
  part {
    content = data.template_file.install_docker.rendered
  }
  part {
    content = data.template_file.install_grafana.rendered
  }
  part {
    content = data.template_file.register-grafana-server-in-consul.rendered
  }
}

