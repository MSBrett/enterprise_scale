variable "root_id" {
  type    = string
  default = "eslz"
}

variable "root_name" {
  type    = string
  default = "ESLZ"
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
    Group       = "eslz"
    Owner       = "nobody@acme.com"
    Project     = "eslz"
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

variable "vpn_key" {
  description = "The shared key for the VPN"
  sensitive   = true
}
