resource "azurerm_resource_group" "arc_rg" {
  provider = azurerm.workload
  name     = "${var.root_id}-${var.location}-arc"
  location = var.location
  tags     = var.client_tags
}