module "enterprise_scale" {
  source = "./terraform-azurerm-caf-enterprise-scale"

  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name

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

}
