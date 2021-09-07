variable "deploy_arc" {
  default = 0
}
variable "deploy_hub" {
  default = 0
}

variable "deploy_domain" {
  default = 0
}

variable "deploy_workload" {
  default = 0
}

variable "scaleset_instance_count" {
  default = 0
}


variable "root_id" {
  type    = string
  default = "eslz"
}

variable "root_name" {
  type    = string
  default = "ESLZ"
}

variable "active_directory_domain" {
  type    = string
  default = "eslz.com"
}

variable "active_directory_netbios_name" {
  type    = string
  default = "ESLZ"
}

variable "subscription_id_workload" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "subscription_id_management" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "subscription_id_identity" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "subscription_id_connectivity" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "location" {
  description = "Azure Region to deploy to"
  default     = "westus"
}


variable "hub_tags" {
  type = map(any)
  default = {
    Environment = "eslz"
    Group       = "NetOps"
    Owner       = "nobody@acme.com"
    Project     = "eslz"
  }
}

variable "domain_tags" {
  type = map(any)
  default = {
    Environment = "eslz"
    Group       = "SecOps"
    Owner       = "nobody@acme.com"
    Project     = "eslz"
  }
}

variable "workload_tags" {
  type = map(any)
  default = {
    Environment = "eslz"
    Group       = "EntOps"
    Owner       = "nobody@acme.com"
    Project     = "eslz"
  }
}

variable "eslz_tags" {
  type = map(any)
  default = {
    Environment = "eslz"
    Group       = "SecOps"
    Owner       = "nobody@acme.com"
    Project     = "eslz"
  }
}

variable "email_security_contact" {
  default = "nobody@acme.com"
}

variable "subnetprefix" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "10.255.128.0/21"
}

variable "onprem_gateway_ip" {
  description = "The IP address/range to allow to connect to to the environment"
  default     = "168.63.129.16"
}

variable "onprem_address_space" {
  description = "The IP address/range to allow to connect to to the environment"
  default     = "192.168.0.0/16"
}

variable "dns_servers" {
  default = ["168.63.129.16"]
}

variable "vm_size" {
  description = "The VM SKU to use"
  default     = "Standard_D2s_v3"
}

variable "vm_disk_sku" {
  description = "The SKU to use for the OS disk"
  default     = "Premium_LRS"
}

variable "admin_username" {
  default = "eslzadmin"
}

variable "admin_password" {
  sensitive = true
}

variable "vpn_key" {
  description = "The shared key for the VPN"
  sensitive   = true
}