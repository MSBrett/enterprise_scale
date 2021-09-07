variable "root_id" {
  type    = string
  default = "eslz"
}

variable "scaleset_instance_count" {
  default = 0
}

variable "root_name" {
  type    = string
  default = "ESLZ"
}

variable "subscription_id_workload" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "subscription_id_connectivity" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "location" {
  description = "Azure Region to deploy to"
  default     = "westus"
}

variable "workload_tags" {
  type = map(any)
  default = {
    Environment = "eslz"
    Group       = "eslz"
    Owner       = "nobody@acme.com"
    Project     = "eslz"
  }
}

variable "subnetprefix" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "10.255.128.0/21"
}

variable "vm_size" {
  description = "The VM SKU to use"
  default     = "Standard_B2s"
}

variable "vm_disk_sku" {
  description = "The SKU to use for the OS disk"
  default     = "Premium_LRS"
}

variable "admin_username" {
  sensitive = true
}

variable "admin_password" {
  sensitive = true
}

variable "active_directory_domain" {
  default = "eslz.com"
}
