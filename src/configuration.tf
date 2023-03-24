variable "vsphere_vcenter_url"{
  description = "vCenter FQDN"
  sensitive   = true
}

variable "vsphere_vcenter_dc"{
  description = "vCenter DC Name"
  sensitive   = true
}

variable "vsphere_datastore_isos"{
  description = "Datastore containing ISOs for VMs"
  sensitive   = true
}

variable "vsphere_datastore_disks"{
  description = "Datastore containing Allocated Disks"
  sensitive   = true
}

variable "parent_folder_name"{
  description = "Project Parent Folder Name"
  type        = string
  default     = "Parent"
}

