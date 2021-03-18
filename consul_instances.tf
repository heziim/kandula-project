resource "aws_instance" "consul_server" {

  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.kandula_key.key_name
  associate_public_ip_address = true
  #subnet_id = module.vpc.public_subnets_ids[count.index]
  subnet_id = element(module.vpc.public_subnets_ids, count.index)

  iam_instance_profile   = aws_iam_instance_profile.consul-join2.name
  vpc_security_group_ids = [aws_security_group.consul.id]

  tags = {
    Name = "consul-server"
    consul_server = "true"
  }
  #user_data = element(data.template_file.consul_server.*.rendered, count.index)
  user_data = data.template_cloudinit_config.all-consul-server.rendered

}



data "template_cloudinit_config" "all-consul-server" {
  gzip = false
  base64_encode = false
  part {
    content = data.template_file.consul_server.rendered
  }
  part {
    content = data.template_file.filebeat.rendered
  }
  part {
    content = data.template_file.node-exporter.rendered
  }
}



