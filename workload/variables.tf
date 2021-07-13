variable "root_id" {
  type    = string
  default = "eslzlab"
}

variable "root_name" {
  type    = string
  default = "ESLZLAB"
}

variable  "subscription_id_workload" {
  default = "00000000-0000-0000-0000-000000000000" 
}

variable  "subscription_id_management" {
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
    Environment = "eslz_lab"
    Group       = "eslz_lab"
    Owner       = "nobody@acme.com"
    Project     = "eslz_lab"
  }
}

variable "client_tags" {
  type = map(any)
  default = {
    Environment = "eslz_lab"
    Group       = "eslz_lab"
    Owner       = "nobody@acme.com"
    Project     = "eslz_lab"
  }
}

variable "subnetprefix" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "10.255.128.0/21"
}

variable "onprem_gateway_ip" {
  description = "The IP address/range to allow to connect to to the environment"
  default     = "1.2.3.4"
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
  default     = "Standard_B2s"
}

variable "vm_disk_sku" {
  description = "The SKU to use for the OS disk"
  default     = "Premium_LRS"
}

variable "admin_username_suffix" {
  default = "admin"
}

variable "admin_password" {
  default   = "P@$$w0rd!@##@!dr0w$$@P"
  sensitive = true
}

variable "vpn_key" {
  description = "The shared key for the VPN"
  sensitive = true
  default = "P@$$w0rd!@##@!dr0w$$@PP@$$w0rd!@##@!dr0w$$@P"
}

#variable "log_analytics_workspace_id" {
#  description = "The ID of the log analytics workspace to connect to"
#  default     = "/subscriptions/${var.subscription_id_management}/resourceGroups/${var.root_id}-mgmt/providers/Microsoft.OperationalInsights/workspaces/${var.root_id}-la"
#}