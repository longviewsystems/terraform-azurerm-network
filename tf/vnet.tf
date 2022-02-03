
module "network" {
  source    = "Azure/network/azurerm"
  vnet_name = "testvnet"
  resource_group_name = module.naming.resource_group.name
  address_spaces      = ["10.0.0.0/16", "10.2.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]
  dns_servers         = ["8.8.8.8", "8.8.4.4"]
  subnet_service_endpoints = {
    "subnet1" : ["Microsoft.AzureActiveDirectory"],
    "subnet2" : ["Microsoft.Storage"],
    "subnet3" : ["Microsoft.Sql"]
  }
  subnet_enforce_private_link_endpoint_network_policies = {
    "subnet1" : true
  }

  tags = var.tags

  depends_on = [azurerm_resource_group.demo]
}