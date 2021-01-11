
output "jenkins_server_public_ip_in_port_8080" {
    value = aws_instance.jenkins_server.public_ip
}

output "eks_cluster_name" {
  value       = local.cluster_name
}

output "consul_servers_public_ip_in_port_8500" {
  value = aws_instance.consul_server.*.public_ip
}

