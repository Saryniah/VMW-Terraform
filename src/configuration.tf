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

variable "vm_linked_clone"{
  description = "Is the VM a linked Clone?"
  type        = bool
}

variable "parent_folder_name"{
  description = "Project Parent Folder Name"
  type        = string
  default     = "Parent"
}

variable "client_list" {
  description = "Names for each VM in Deployment"
  type = list(object({
    name = string
    ip = string
    hostname = string
  }))
}


