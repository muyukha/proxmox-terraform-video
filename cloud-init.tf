data "template_file" "cloud_init" {
  template = file("${path.module}/files/docker-kind-podman.cloud_config")

  vars = {
    hostname = local.vm_hostname
    passwd   = local.vm_hashed_password
    # sh_key  = local.public_ssh_key
    ssh_user = local.vm_user
  }
}

resource "local_file" "cloud_init" {
  content  = data.template_file.cloud_init.rendered
  filename = "${path.module}/files/user_data_cloud_init.cfg"
}

// We are not going to add ssh keys to the vm for now

/* data "template_file" "private_ssh_key" {
  template = file("${path.module}/files/id_rsa")
  vars = {
    priv_ssh_key = local.priv_ssh_key
  }
}

resource "local_file" "private_ssh_key" {
  content  = data.template_file.private_ssh_key.rendered
  filename = "${path.module}/files/id_rsa.priv_key"
}

data "template_file" "public_ssh_key" {
  template = file("${path.module}/files/id_rsa.pub")
  vars = {
    public_ssh_key = local.public_ssh_key
  }
}
resource "local_file" "public_ssh_key" {
  content  = data.template_file.public_ssh_key.rendered
  filename = "${path.module}/files/id_rsa.pub_key"
}
 */

resource "null_resource" "cloud_init" {
  triggers = {
    key = uuid()
  }
  connection {
    type     = "ssh"
    user     = local.pve_host_user
    password = local.pm_password
    host     = local.pve_host
  }
  provisioner "file" {
    source      = local_file.cloud_init.filename
    destination = "/tmp/cloud_init_docker_kind_podman.yml"
  }
  provisioner "file" {
    source      = "files/ubuntu_20_cloud_template.sh"
    destination = "/tmp/ubuntu_20_cloud_template.sh"
  }
  provisioner "file" {
    source      = "files/resolv.conf"
    destination = "/etc/resolv.conf"
  }

  provisioner "file" {
    source      = "files/pve-enterprise.list"
    destination = "/etc/apt/sources.list.d/pve-enterprise.list"
  }
  provisioner "file" {
    source      = "files/ceph.list"
    destination = "/etc/apt/sources.list.d/ceph.list"
  }
  provisioner "remote-exec" {
    inline = [
      "apt update -y",
      "rm -rf /var/lib/vz/snippets",
      "mkdir -p /var/lib/vz/snippets",
      "cp /tmp/cloud_init_docker_kind_podman.yml /var/lib/vz/snippets/cloud_init_docker_kind_podman.yml",
      "chmod +x /tmp/ubuntu_20_cloud_template.sh",
      "/tmp/ubuntu_20_cloud_template.sh",
      "sleep 10s"

    ]
  }
}

resource "null_resource" "cloud-init-git-config" {
  depends_on = [proxmox_vm_qemu.kubernetes]
  triggers = {
    key = uuid()
  }
  connection {
    type     = "ssh"
    user     = local.vm_user
    password = local.vm_password
    host     = local.vm_ip_address
  }

  // We are not going to add ssh keys to the vm for now

 /*  provisioner "file" {
    source      = "files/id_rsa.priv_key"
    destination = "/tmp/id_rsa.priv_key"
  }
  provisioner "file" {
    source      = "files/id_rsa.pub_key"
    destination = "/tmp/id_rsa.pub_key"
  }
 */
 
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p ~/.ssh",
      "base64 -d /tmp/id_rsa.priv_key > /tmp/id_rsa",
      "sudo mv /tmp/id_rsa ~/.ssh/id_rsa",
      "sudo mv /tmp/id_rsa.pub_key ~/.ssh/id_rsa.pub",
      "sudo echo \"StrictHostKeyChecking no\" >> ~/.ssh/config",
      "sudo cat  ~/.ssh/id_rsa.pub >> ~/.ssh/known_hosts",
      "sudo chmod 0400 ~/.ssh/id_rsa",
      "sudo snap install terraform --classic",
    ]
  }
}
