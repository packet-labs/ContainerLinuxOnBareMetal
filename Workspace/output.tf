output "Server_IPs_v4" {
  value = packet_device.hosts.*.access_public_ipv4
}

output "SSH_Access_Servers" {
  value = {
    for server in packet_device.hosts:
    server.hostname => "ssh core@${server.access_public_ipv4}"
  }
}