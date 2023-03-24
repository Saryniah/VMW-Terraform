locals {
    secrets = jsondecode(file("${path.module}/secrets.json"))
}

terraform {
    required_providers {
        vsphere = {
            source = "hashicorp/vsphere"
            version = ">= 2.0"
        }
    }
}

provider "vsphere" {
  user = local.secrets.vcenter_user
  password = local.secrets.vcenter_pass
  vsphere_server = var.vsphere_vcenter_url
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_vcenter_dc
}

data "vsphere_datastore" "isos"{
  name          = var.vsphere_datastore_isos
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "parent" {
  path = var.parent_folder_name
  type = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}