data "azurerm_resource_group" "vnet" {
  name = var.resource_group_name
}


module "network" {
  source                   = "Azure/network/azurerm"
  version                  = "3.5.0"
  vnet_name                = var.vnet_name
  resource_group_name      = data.azurerm_resource_group.vnet.name
  address_spaces           = var.address_spaces
  subnet_prefixes          = var.subnet_prefixes
  subnet_names             = var.subnet_names
  dns_servers              = var.dns_servers
  subnet_service_endpoints = var.subnet_service_endpoints
  subnet_enforce_private_link_endpoint_network_policies = {
    "subnet1" : true
  }
  tags = var.tags
}
