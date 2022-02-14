resource "network-security-group" "nsg" {
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
  network_security_group_name = var.nsg_name
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
  network_security_group_name = var.nsg_name
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["8080", "1000-2000"]
  source_address_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]
  destination_address_prefix  = "*"
}