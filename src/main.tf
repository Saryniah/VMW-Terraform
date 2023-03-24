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
    vsphere_server = local.secrets.vcenter_url
    allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {

}

resource "vsphere_folder" "parent" {
    path = "VMFolder"
    type = "vm"
    datacenter_id = data.vsphere_datacenter.dc.id
}