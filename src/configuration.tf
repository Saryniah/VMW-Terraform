variable "vsphere_vcenter_url"{
  description = "vCenter FQDN"
  sensitive   = true
}

variable "vsphere_vcenter_dc"{
  description = "vCenter DC Name"
  sensitive   = true
}

variable "deployment_host"{
  description = "vSphere host for deployment"
  sensitive = true
}

variable "vsphere_datastore_isos"{
  description = "Datastore containing ISOs for VMs"
  sensitive   = true
}

variable "vsphere_datastore_disks"{
  description = "Datastore containing Allocated Disks"
  sensitive   = true
}

variable "vm_template"{
  description = "Template used to create stack"
  type        = string
}

variable "vm_network"{
  description = "Network to be used for VMs in deployment"
  type        = string
}

variable "vm_name_base"{
  description = "Basename for VM"
  type        = string
}

variable "vm_children_are_linked_clones"{
  description = "Are the kids linked clones?"
  type        = bool
}

variable "parent_folder_name"{
  description = "Project Parent Folder Name"
  type        = string
}

variable "vm_gateway" {
  description = "Project VM's Network Gateway"
  type        = string
}

variable "vm_parent_hostname"{
  description = "Project Parent VM's hostname"
  type = string
}

variable "vm_parent_ip" {
  description = "Project Parent VM's IP"
  type        = string
}

variable "vm_netmask" {
  description = "Project VM's Network netmask"
  type        = string
}

variable "vm_domain" {
  description = "Project VM's domain name"
  type        = string
}

variable "client_list" {
  description = "Names for each VM in Deployment"
  type = list(object({
    name = string
    ip = string
    hostname = string
  }))
}


