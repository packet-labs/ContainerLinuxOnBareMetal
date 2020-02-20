resource "null_resource" "lab-software" {
  depends_on = [packet_device.lab-master]

  connection {
    user        = "root"
    private_key = tls_private_key.default.private_key_pem
    host        = packet_device.lab-master.access_public_ipv4
    agent       = false
    timeout     = "30s"
  }

  provisioner "file" {
    source      = "nginx_userdir.conf"
    destination = "/etc/nginx/conf.d/userdir.conf"
  }
  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install git unzip nginx -y",
      "rm /etc/nginx/sites-enabled/default",
      "systemctl reload nginx",
      "wget https://releases.hashicorp.com/terraform/0.12.16/terraform_0.12.16_linux_amd64.zip",
      "unzip terraform_0.12.16_linux_amd64.zip",
      "mv terraform /usr/local/bin",
      "rm terraform_0.12.16_linux_amd64.zip",
      "wget -O /usr/local/bin/ct https://github.com/coreos/container-linux-config-transpiler/releases/download/v0.9.0/ct-v0.9.0-x86_64-unknown-linux-gnu",
      "chmox +x /usr/local/bin/ct",
    ]
  }
}

