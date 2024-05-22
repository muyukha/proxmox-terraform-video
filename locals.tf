locals {
  vm_ipconfig        = "ip=192.168.0.60/24,gw=192.168.0.1" // TO CHANGE
  vm_password        = "88888888" // TO CHANGE
  vm_hashed_password = "$1$Avf8.0aB$dSbAjX4CkgPOM.uo9byHf1" // TO CHANGE (Hash the password openssl passwd -1 'yourpassword')
  vm_user            = "example-user" // TO CHANGE
  vm_hostname        = "proxmox-example" // TO CHANGE
  vm_ip_address      = "192.168.0.60" // TO CHANGE
  pm_password        = "88888888" // TO CHANGE
  pm_user            = "root@pam" // TO CHANGE
  pve_host           = "192.168.0.89" // TO CHANGE
  pve_host_hostname  = "proxmox-test" // TO CHANGE
  pve_host_user      = "root" // TO CHANGE
  /* public_ssh_key     = ""
  priv_ssh_key       = "" */
}
