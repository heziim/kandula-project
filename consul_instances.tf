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
    Name = "consul-server${count.index+1}"
    consul_server = "true"
  }
  user_data = element(data.template_file.consul_server.*.rendered, count.index)
}

/*
resource "aws_instance" "consul_agent" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.kandula_key.key_name

  iam_instance_profile   = aws_iam_instance_profile.consul-join2.name
  vpc_security_group_ids = [aws_security_group.consul.id]

  tags = {
    Name = "consul-agent-web-server"
  }
  user_data = data.template_cloudinit_config.web-agent.rendered
}
*/

data "template_file" "consul_server" {
  count    = 3
  template = file("templates/consul.sh.tpl")

  vars = {
    consul_version = var.consul_version
    config = <<EOF
      "node_name": "consul-server-${count.index+1}",
      "server": true,
      "bootstrap_expect": 3,
      "ui": true,
      "client_addr": "0.0.0.0"
    EOF
  }
}


data "template_file" "consul_client" {
  #count    = var.clients
  count    = 3
  template = file("templates/consul.sh.tpl")

  vars = {
      consul_version = var.consul_version
      config = <<EOF
        "node_name": "jenkins-${count.index+1}",
        "enable_script_checks": true,
        "server": false
      EOF
  }
}

