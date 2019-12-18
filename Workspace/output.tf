output "Server_IPs_v4" {
  value = packet_device.hosts.*.access_public_ipv4
}

output "Server_IPs_v6" {
  value = packet_device.hosts.*.access_public_ipv6
}

output "Anycast_IPv6_Address" {
  value = local.anycast_addr_1
}

output "Anycast_IPv6_Network" {
  value = local.anycast_network
}

output "IPv6_Anycast_Curl_Command" {
  value = "curl http://[${local.anycast_addr_1}]"
}

output "SSH_Access_Server_0" {
  value = "ssh root@${packet_device.hosts[0].access_public_ipv4} -i mykey"
}

