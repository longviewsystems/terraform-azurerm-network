
#------------------------
# Local declarations
#------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}

data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}


resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

#-------------------------------------
# VNET Creation - Default is "true"
#-------------------------------------

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnetwork_name
  location            = local.location
  resource_group_name = local.resource_group_name
  dns_servers         = var.dns_servers
  address_space       = var.vnet_address_space
  tags                = var.tags

}

#--------------------------------------------------------------------------------------------------------
# Subnets Creation with, NSG Association
#--------------------------------------------------------------------------------------------------------


resource "azurerm_subnet" "snet" {
  for_each                                       = var.subnets
  name                                           = each.value.subnet_name
  resource_group_name                            = local.resource_group_name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = each.value.subnet_address_prefix
  service_endpoints                              = lookup(each.value, "service_endpoints", [])
  enforce_private_link_endpoint_network_policies = lookup(each.value, "enforce_private_link_endpoint_network_policies", null)



}

#-----------------------------------------------
# Network security group - Default is "false"
#-----------------------------------------------
resource "azurerm_network_security_group" "nsg" {
  for_each            = var.subnets
  name                = each.value["nsg_name"]
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = var.tags
  dynamic "security_rule" {
    for_each = concat(lookup(each.value, "nsg_inbound_rules", []), lookup(each.value, "nsg_outbound_rules", []))
    content {
      name                       = security_rule.value[0] == "" ? "Default_Rule" : security_rule.value[0]
      priority                   = security_rule.value[1]
      direction                  = security_rule.value[2] == "" ? "Inbound" : security_rule.value[2]
      access                     = security_rule.value[3] == "" ? "Allow" : security_rule.value[3]
      protocol                   = security_rule.value[4] == "" ? "Tcp" : security_rule.value[4]
      source_port_range          = "*"
      destination_port_range     = security_rule.value[5] == "" ? "*" : security_rule.value[5]
      source_address_prefix      = security_rule.value[6] == "" ? element(each.value.subnet_address_prefix, 0) : security_rule.value[6]
      destination_address_prefix = security_rule.value[7] == "" ? element(each.value.subnet_address_prefix, 0) : security_rule.value[7]
      description                = "${security_rule.value[2]}_Port_${security_rule.value[5]}"
    }
  }
}
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each                  = var.subnets
  subnet_id                 = azurerm_subnet.snet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

resource "azurerm_route_table" "route_table" {
  for_each                      = var.subnets
  name                          = each.value["route_table_name"]
  location                      = local.location
  resource_group_name           = local.resource_group_name
  disable_bgp_route_propagation = each.value["disable_bgp_route_propagation"]
  tags                          = var.tags
  dynamic "route" {
    for_each = lookup(each.value, "route_entries", [])
    content {
      name                   = route.value[0] == "" ? "default" : route.value[0]
      address_prefix         = route.value[1] == "" ? "0.0.0.0/0" : route.value[1]
      next_hop_type          = route.value[2] == "" ? "Internet" : route.value[2]
      next_hop_in_ip_address = contains(keys(route.value[3]), "next_hop_in_ip_address") ? route.value[3] : null
    }
  }
}

resource "azurerm_subnet_route_table_association" "route_table_association" {
  for_each       = var.subnets
  subnet_id      = azurerm_subnet.snet[each.key].id
  route_table_id = azurerm_route_table.route_table[each.key].id
}