variable "deploy_hub" {
  default = 0
}

variable "deploy_workload" {
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
    Group       = "eslz"
    Owner       = "nobody@acme.com"
    Project     = "eslz"
  }
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

variable "eslz_tags" {
  type = map(any)
  default = {
    Environment = "eslz"
    Group       = "eslz"
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
  default     = "Standard_F4s_v2"
}

variable "vm_disk_sku" {
  description = "The SKU to use for the OS disk"
  default     = "Premium_LRS"
}

variable "admin_username_suffix" {
  default = "eslzadmin"
}

variable "admin_password" {
  sensitive = true
}

variable "vpn_key" {
  description = "The shared key for the VPN"
  sensitive   = true
}

locals {
  configure_management_resources = {
    settings = {
      log_analytics = {
        enabled = true
        config = {
          retention_in_days                           = 30
          enable_monitoring_for_arc                   = true
          enable_monitoring_for_vm                    = true
          enable_monitoring_for_vmss                  = true
          enable_solution_for_agent_health_assessment = true
          enable_solution_for_anti_malware            = true
          enable_solution_for_azure_activity          = true
          enable_solution_for_change_tracking         = true
          enable_solution_for_service_map             = true
          enable_solution_for_sql_assessment          = true
          enable_solution_for_updates                 = true
          enable_solution_for_vm_insights             = true
          enable_sentinel                             = true
        }
      }
      security_center = {
        enabled = true
        config = {
          email_security_contact             = "${var.email_security_contact}"
          enable_defender_for_acr            = true
          enable_defender_for_app_services   = true
          enable_defender_for_arm            = true
          enable_defender_for_dns            = true
          enable_defender_for_key_vault      = true
          enable_defender_for_kubernetes     = true
          enable_defender_for_servers        = true
          enable_defender_for_sql_servers    = true
          enable_defender_for_sql_server_vms = true
          enable_defender_for_storage        = true
        }
      }
    }

    location = var.location
    tags     = var.eslz_tags
    advanced = null
  }
}