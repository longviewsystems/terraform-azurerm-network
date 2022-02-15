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

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.locations
  resource_group_name = data.azurerm_resource_group.vnet.name
  tags                = var.tags
}

#############################
#   Single port and prefix rules   #
#############################

resource "azurerm_network_security_rule" "mysql" {
  name                        = "my-mysql-rule"
  resource_group_name         = data.azurerm_resource_group.vnet.name
  network_security_group_name = azurerm_network_security_group.nsg.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = "10.0.1.0/24"
  destination_address_prefix  = "*"
}

#############################
#  Multiple ports and prefixes rules  #
#############################

resource "azurerm_network_security_rule" "custom" {
  name                        = "my-custom-rule"
  resource_group_name         = data.azurerm_resource_group.vnet.name
  network_security_group_name = azurerm_network_security_group.nsg.name
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["8080", "1000-2000"]
  source_address_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]
  destination_address_prefix  = "*"
}