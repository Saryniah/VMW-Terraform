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

data "vsphere_host" "host"{
  name          = var.deployment_host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "isos"{
  name          = var.vsphere_datastore_isos
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "disks"{
  name          = var.vsphere_datastore_disks
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network"{
  name          = var.vm_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template"{
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "parent" {
  path = var.parent_folder_name
  type = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "primary_vm"{
  name          = var.vm_name_base
  folder        = vsphere_folder.parent.path
  resource_pool_id = data.vsphere_host.host.resource_pool_id
  datastore_id  = data.vsphere_datastore.disks.id
  num_cpus      = data.vsphere_virtual_machine.template.num_cpus
  memory        = data.vsphere_virtual_machine.template.memory
  firmware      = data.vsphere_virtual_machine.template.firmware
  guest_id      = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk{
    label = "${var.vm_name_base}.vmdk"
    size = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  wait_for_guest_ip_timeout = 0
  wait_for_guest_net_timeout = 0

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone = false
  }

  lifecycle{
    ignore_changes = []
  }

}

resource "vsphere_virtual_machine_snapshot" "primary_vm_snapshot" {
  virtual_machine_uuid = vsphere_virtual_machine.primary_vm.uuid
  snapshot_name = "Primary VM"
  description = "Primary VM Initial State"
  memory = true
  quiesce = true
  remove_children = true
  consolidate = true
}

resource "vsphere_virtual_machine" "child_vm"{
  for_each      = {for each in var.client_list : each.name => each}
  name          = each.value.name
  folder        = vsphere_folder.parent.path
  resource_pool_id = data.vsphere_host.host.resource_pool_id
  datastore_id  = data.vsphere_datastore.disks.id
  num_cpus      = data.vsphere_virtual_machine.template.num_cpus
  memory        = data.vsphere_virtual_machine.template.memory
  firmware      = data.vsphere_virtual_machine.template.firmware
  guest_id      = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk{
    label = "${var.vm_name_base}.vmdk"
    size = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone{
    template_uuid = vsphere_virtual_machine_snapshot.primary_vm_snapshot.virtual_machine_uuid
    linked_clone = var.vm_children_are_linked_clones
    customize {
      linux_options {
        host_name = each.value.hostname
        domain = var.vm_domain
        
      }
      network_interface {
        ipv4_address = each.value.ip
        ipv4_netmask = var.vm_netmask
      }
      ipv4_gateway = var.vm_gateway

    }
  }

  lifecycle{
    ignore_changes = []
  }

}

