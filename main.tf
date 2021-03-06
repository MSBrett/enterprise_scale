data "azurerm_client_config" "current" {}

module "enterprise_scale" {
  source         = "Azure/caf-enterprise-scale/azurerm"
  version = "0.3.3"
  
  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "./lib"

  default_location            = var.location
  deploy_core_landing_zones   = true
  deploy_management_resources = true
  deploy_demo_landing_zones   = false

  subscription_id_management   = var.subscription_id_management
  subscription_id_identity     = var.subscription_id_identity
  subscription_id_connectivity = var.subscription_id_connectivity

  subscription_id_overrides = {
    landing-zones = [
      "${var.subscription_id_workload}"
    ]
  }

  configure_management_resources = local.configure_management_resources

  providers = {
    azurerm            = azurerm.management
  }
}

module "hub_network" {
  source                       = "./core-hubnetwork"
  count                        = var.deploy_hub > 0 ? 1 : 0
  depends_on                   = [ module.enterprise_scale ]
  root_id                      = var.root_id
  root_name                    = var.root_name
  subscription_id_connectivity = var.subscription_id_connectivity
  location                     = var.location
  hub_tags                     = var.hub_tags
  subnetprefix                 = var.subnetprefix
  onprem_gateway_ip            = var.onprem_gateway_ip
  onprem_address_space         = var.onprem_address_space
  dns_servers                  = var.dns_servers
  vpn_key                      = var.vpn_key
  providers = {
    azurerm              = azurerm.connectivity
    azurerm.connectivity = azurerm.connectivity
  }
}

module "windows_domain" {
  source                       = "./core-domain"
  count                        = var.deploy_domain > 0 ? 1 : 0
  depends_on                   = [ module.enterprise_scale, module.hub_network ]
  root_id                      = var.root_id
  root_name                    = var.root_name
  subscription_id_identity     = var.subscription_id_identity
  location                     = var.location
  domain_tags                  = var.domain_tags
  subnetprefix                 = var.subnetprefix
  vm_size                      = var.vm_size
  vm_disk_sku                  = var.vm_disk_sku
  admin_username               = var.admin_username
  admin_password               = var.admin_password
  active_directory_domain       = var.active_directory_domain
  active_directory_netbios_name = var.active_directory_netbios_name
  providers = {
    azurerm              = azurerm.identity
    azurerm.connectivity = azurerm.connectivity
    azurerm.identity     = azurerm.identity
  }
}

module "workload_vm" {
  source                       = "./workload-vm"
  count                        = var.deploy_workload > 0 ? 1 : 0
  depends_on                   = [ module.enterprise_scale, module.hub_network ]
  root_id                      = var.root_id
  root_name                    = var.root_name
  subscription_id_connectivity = var.subscription_id_connectivity
  subscription_id_workload     = var.subscription_id_workload
  location                     = var.location
  workload_tags                  = var.workload_tags
  subnetprefix                 = var.subnetprefix
  vm_size                      = var.vm_size
  vm_disk_sku                  = var.vm_disk_sku
  admin_username               = var.admin_username
  admin_password               = var.admin_password
  active_directory_domain       = var.active_directory_domain
  scaleset_instance_count      = var.scaleset_instance_count
  providers = {
    azurerm              = azurerm.workload
    azurerm.connectivity = azurerm.connectivity
    azurerm.identity     = azurerm.identity
    azurerm.workload     = azurerm.workload
  }
}

module "workload_arc" {
  source                       = "./workload-arc"
  count                        = var.deploy_arc > 0 ? 1 : 0
  depends_on                   = [ module.enterprise_scale, module.hub_network ]
  root_id                      = var.root_id
  root_name                    = var.root_name
  subscription_id_workload     = var.subscription_id_workload
  location                     = var.location
  workload_tags                  = var.workload_tags
  providers = {
    azurerm              = azurerm.workload
    azurerm.workload     = azurerm.workload
  }
}