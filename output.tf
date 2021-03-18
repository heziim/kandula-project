output "eks_cluster_name" {
  value       = local.cluster_name
}

output "jenkins_server_public_ip_in_port_8080" {
  value = aws_instance.jenkins_server.*.public_ip
}

output "consul_servers_public_ip_in_port_8500" {
  value = aws_instance.consul_server.*.public_ip
}

output "grafana_server_public_ip_in_port_3000" {
  value = aws_instance.grafana_server.*.public_ip
}

output "prometheus_server_public_ip_in_port_9090" {
  value = aws_instance.prometheus_server.*.public_ip
}

output "kibana_server_public_ip_in_port_5601" {
  value = aws_instance.elk_server.*.public_ip
}

