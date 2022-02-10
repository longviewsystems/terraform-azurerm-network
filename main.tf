
module "network" {
  source              = "Azure/network/azurerm"
  vnet_name           = "testvnet"
  resource_group_name = data.azurerm_resource_group.vnet.name
  address_spaces      = var.address_spaces
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names
  dns_servers         = var.dns_servers
  subnet_service_endpoints = var.subnet_service_endpoints
  subnet_enforce_private_link_endpoint_network_policies = {
    "subnet1" : true
  }

  tags = var.tags


}