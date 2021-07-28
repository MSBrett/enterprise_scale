variable "root_id" {
  type    = string
  default = "eslz"
}

variable "root_name" {
  type    = string
  default = "ESLZ"
}

variable "subscription_id_workload" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "location" {
  description = "Azure Region to deploy to"
  default     = "westus"
}

variable "client_tags" {
  type = map(any)
  default = {
    Environment = "eslz"
    Group       = "eslz"
    Owner       = "nobody@acme.com"
    Project     = "eslz"
  }
}
