data "template_file" "filebeat" {
  template = file("templates/filebeat.sh.tpl")
  vars = {
  }
}

data "template_file" "inst_helm" {
  template = file("templates/inst_helm.sh.tpl")
  vars = {
  }
}

data "template_file" "node-exporter" {
  template = file("templates/node-exporter.sh.tpl")
  vars = {
  }
}

data "template_file" "elk" {
  template = file("templates/elk.sh.tpl")
  vars = {
  }
}

data "template_file" "install_docker" {
  template = file("templates/inst_docker.sh.tpl")
  vars = {
  }
}

data "template_file" "install_prometheus" {
  template = file("templates/inst_prometheus.sh.tpl")
  vars = {
  }
}

data "template_file" "install_grafana" {
  template = file("templates/inst_grafana.sh.tpl")
  vars = {
  }
}

data "template_file" "register-grafana-server-in-consul" {
  template = file("templates/register-grafana-server-in-consul.sh.tpl")
  vars = {
  }
}

data "template_file" "register-kibana-server-in-consul" {
  template = file("templates/register-kibana-server-in-consul.sh.tpl")
  vars = {
  }
}

data "template_file" "register-jenkins-server-in-consul" {
  template = file("templates/register-jenkins-server-in-consul.sh.tpl")
  vars = {
  }
}

data "template_file" "register-prometheus-server-in-consul" {
  template = file("templates/register-prometheus-server-in-consul.sh.tpl")
  vars = {
  }
}

data "template_file" "jenkins-server-docker" {
  template = file("templates/jenkins-server-docker.sh.tpl")
  vars = {
    jenkins_home_mount = "/home/ubuntu/jenkins_home:/var/jenkins_home"
    docker_sock_mount = "/var/run/docker.sock:/var/run/docker.sock"
    java_opts = "JAVA_OPTS='-Djenkins.install.runSetupWizard=false'"
  }

}

data "template_file" "consul_server" {
  template = file("templates/consul.sh.tpl")

  vars = {
    consul_version = var.consul_version
    config = <<EOF
      "server": true,
      "bootstrap_expect": 3,
      "ui": true,
      "client_addr": "0.0.0.0",
      "telemetry": {
        "prometheus_retention_time": "10m"
      }
    EOF
  }
}


data "template_file" "consul_agent" {
  template 	= file("templates/consul.sh.tpl")

  vars = {
      consul_version = var.consul_version
      config = <<EOF
        "enable_script_checks": true,
        "server": false
      EOF
  }
}


