output "Server_IPs_v4" {
  value = packet_device.hosts.*.access_public_ipv4
}

output "SSH_Access_Server_0" {
  value = "ssh core@${packet_device.hosts[0].access_public_ipv4} -i mykey"
}
