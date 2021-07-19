module "enterprise_scale_foundation" {
  source                       = "./foundation"
  root_id                      = var.root_id
  root_name                    = var.root_name
  subscription_id_workload     = var.subscription_id_workload
  subscription_id_management   = var.subscription_id_management
  subscription_id_identity     = var.subscription_id_identity
  subscription_id_connectivity = var.subscription_id_connectivity
  location                     = var.location
  eslz_tags                    = var.eslz_tags
  email_security_contact       = var.email_security_contact
}

module "hub_network" {
  source                       = "./hubnetwork"
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
}


module "workload_workstation" {
  source  = "./workload-wks"
  root_id = var.root_id
  root_name = var.root_name
  subscription_id_connectivity = var.subscription_id_connectivity
  subscription_id_workload = var.subscription_id_workload
  location = var.location
  client_tags = var.client_tags
  subnetprefix = var.subnetprefix
  vm_size = var.vm_size
  vm_disk_sku = var.vm_disk_sku
  admin_username_suffix = var.admin_username_suffix
  admin_password = var.admin_password
}
