resource "proxmox_vm_qemu" "kubernetes" {
  depends_on  = [null_resource.cloud_init]
  count       = 1
  name        = local.vm_hostname
  cicustom    = "user=local:snippets/cloud_init_docker_kind_podman.yml"
  target_node = local.pve_host_hostname
  onboot      = true
  clone       = "ubuntu-cloud-template"
  vmid        = 8001
  agent       = 1
  os_type     = "cloud-init"
  cores       = 4
  sockets     = 1
  cpu         = "host"
  memory      = 10240
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  disk {
    slot     = 0
    size     = "40G"
    type     = "scsi"
    storage  = "local-lvm"
    iothread = 0
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  ipconfig0 = local.vm_ipconfig

}
