
resource "aws_instance" "jenkins_server" {
  # count = 2
  ami           		= data.aws_ami.ubuntu.id
  instance_type 		= "t2.micro"
  associate_public_ip_address 	= true
  # subnet_id = module.vpc.public_subnets_ids[count.index]
  subnet_id 			= module.vpc.public_subnets_ids[0]
  key_name 			= aws_key_pair.kandula_key.key_name
  #depends_on = module.vpc.internet_gw
  vpc_security_group_ids 	= [aws_security_group.kandula_jenkins_server.id,aws_security_group.consul.id]
  iam_instance_profile   	= aws_iam_instance_profile.consul-join2.name

  tags = {
    Name = "kandula-jenkins-server"
  }
  user_data = data.template_cloudinit_config.all-jenkins-server.rendered
}


resource "aws_instance" "jenkins_agents" {
  count 			= 2
  ami           		= data.aws_ami.ubuntu.id
  instance_type 		= "t2.micro"
  subnet_id 			= module.vpc.private_subnets_ids[count.index]
  key_name 			= aws_key_pair.kandula_key.key_name
  vpc_security_group_ids 	= [aws_security_group.consul.id]
  iam_instance_profile   	= aws_iam_instance_profile.admin-access.name
  depends_on 			= [module.vpc.igw,module.vpc.natgw]

  tags = {
    Name = "kandula_jenkins_agent"
  }
  user_data = data.template_cloudinit_config.all-jenkins-client.rendered
}


data "template_cloudinit_config" "all-jenkins-server" {
  gzip = false
  base64_encode = false
  part {
    content = data.template_file.consul_agent.rendered
  }
  part {
    content = data.template_file.jenkins-server-docker.rendered
  }
  part {
    content = data.template_file.filebeat.rendered
  }
  part {
    content = data.template_file.node-exporter.rendered
  }
  part {
    content = data.template_file.register-jenkins-server-in-consul.rendered
  }
}

data "template_cloudinit_config" "all-jenkins-client" {
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
    content = data.template_file.inst_helm.rendered
  }
}
