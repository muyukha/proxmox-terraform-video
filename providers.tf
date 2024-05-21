# should this be in a providers.tf
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.5"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://${local.pve_host}:8006/api2/json"
  pm_password     = local.pm_password
  pm_user         = local.pm_user
  pm_tls_insecure = true
  pm_debug        = true
}
