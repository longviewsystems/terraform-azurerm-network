/*resource "random_id" "rg_name" {
  byte_length = 8
}*/

resource "azurerm_resource_group" "vnet" {
  name     = "test-${random_id.rg_name.hex}-rg"
  location = var.locations
  tags     = var.tags
}

module "network" {
  source                   = "../../" #testing root module.
  resource_group_name      = azurerm_resource_group.vnet.name
  vnet_name                = var.vnet_name
  locations                = var.locations
  address_spaces           = var.address_spaces
  subnet_prefixes          = var.subnet_prefixes
  subnet_names             = var.subnet_names
  subnet_service_endpoints = var.subnet_service_endpoints
  tags                     = var.tags
}