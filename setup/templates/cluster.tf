#################
### Variables ###
#################
variable "lab_name" {}
variable "packet_project_id" {}
variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
variable "number_of_nodes" {
  default = 1
}
variable "plan" {
  default = "t1.small.x86"
}
variable "facility" {
  default = "any"
}
variable "operating_system" {
default = "{{ operating_system }}"
}
#################
### Providers ###
#################

provider "packet" {
}

############
### Data ###
############
# External IP v4
data "http" "publicv4" {
  url = "http://ipv4.icanhazip.com"
}
data "ignition_config" "remote" {
    replace {
      source = "http://${chomp(data.http.publicv4.body)}/ignition.json"
    }
}

#################
### Resources ###
#################

resource "packet_ssh_key" "ssh-key" {
  name       = "${var.lab_name}"
  public_key = "${chomp(file(var.public_key_path))}"
}



resource "packet_device" "hosts" {
  depends_on = ["packet_ssh_key.ssh-key"]

  hostname = "${var.lab_name}-${count.index + 1}"

  plan             = "${var.plan}"
  facilities       = ["${var.facility}"]
  operating_system = "${var.operating_system}"
  billing_cycle    = "hourly"
  project_id       = "${var.packet_project_id}"
  count            = "${var.number_of_nodes}"
  user_data        = "${data.ignition_config.remote.rendered}"

  tags = ["${var.lab_name}"]
}

###############
### Outputs ###
###############
output "hosts_ips" {
  value = "${packet_device.hosts.*.access_public_ipv4}"
}