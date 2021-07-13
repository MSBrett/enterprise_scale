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

# Declare the Terraform Module for Cloud Adoption Framework
# Enterprise-scale and provide a base configuration.

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
          email_security_contact             = "nobody@acme.com"
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
    tags = {
      Environment = "eslz_lab"
      Group       = "eslz_lab"
      Owner       = "nobody@acme.com"
      Project     = "eslz_lab"
    }
    advanced = null
  }
}
