resource "aws_instance" "elk_server" {
  ami                           = data.aws_ami.ubuntu.id
  instance_type                 = "t3.medium"
  associate_public_ip_address   = true
  subnet_id                     = module.vpc.public_subnets_ids[1]
  key_name                      = aws_key_pair.kandula_key.key_name
  #depends_on 			= [module.vpc.internet_gw]
  vpc_security_group_ids        = [aws_security_group.elk_server.id,aws_security_group.consul.id]
  iam_instance_profile          = aws_iam_instance_profile.consul-join2.name

  tags = {
    Name = "kibana_elasticsearch_server"
  }
  user_data = data.template_cloudinit_config.all-elk.rendered
}

data "template_cloudinit_config" "all-elk" {
  gzip = false
  base64_encode = false
  part {
    content = data.template_file.consul_agent.rendered
  }
  part {
    content = data.template_file.elk.rendered
  }
  part {
    content = data.template_file.filebeat.rendered
  }
  part {
    content = data.template_file.node-exporter.rendered
  }
  part {
    content = data.template_file.register-kibana-server-in-consul.rendered
  }
}

