resource "packet_ssh_key" "ssh-key" {
  name       = "mykey"
  public_key = file("mykey.pub")
}

# testing with IPv6
#resource "packet_reserved_ip_block" "elastic_ip" {
#  project_id = "var.packet_project_id"
#  type       = "public_ipv4"
#  quantity   = 1
#}

resource "packet_device" "hosts" {
  depends_on = [packet_ssh_key.ssh-key]

  hostname = format("%s-%s-%02d", var.lab_name, var.facility, count.index)

  plan             = "t1.small.x86"
  facilities       = [var.facility]
  operating_system = "flatcar_stable"
  billing_cycle    = "hourly"
  project_id       = var.packet_project_id
  count            = var.instance_count
  tags             = [var.lab_name]

  user_data        = templatefile("userdata.tmpl", {})
#  user_data        = file("userdata.tmpl")

  connection {
    host        = self.access_public_ipv4
    type        = "ssh"
    user        = "root"
    private_key = file("mykey")
  }
}

