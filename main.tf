#------------------------
# Local declarations
#------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}


#TODO: Remove Resource Group creation.  Get an ID for the Resource Group.
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

#TODO: Remove Resource Group creation.  Get an ID for the Resource Group.
resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  #TODO: take tags directly from variable.  
  tags     = merge({ "Name" = format("%s", var.resource_group_name) }, var.tags, )
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
  #TODO: take tags directly from variable.  
  tags                = merge({ "Name" = format("%s", var.vnetwork_name) }, var.tags, )

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
  for_each = var.subnets
  name                = each.value["nsg_name"]
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = merge({ "ResourceName" = lower("nsg_${each.key}_in") }, var.tags, )
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

#TODO: Build a local variable (local.routeTableAssociation) to control the loop.
# #if var.assign_routes = false, local.routeTableAssociation = null, {} - one of those.
# otherwise, local.routeTableAssociation = map(subnet name, route table name)

#TODO: Add loop to associate RouteTable ID to subnet.  RouteTable name is an input in the subnet variable block.
# resource "azurerm_subnet_route_table_association" "default_route_table_association" {
#   for_each = ...   # local.routeTableAssociation
#   subnet_id      = azurerm_subnet.subnet[each.key].id
#   Assign route table by name (the name of the route table is an input in the subnet variable block)
#   If there's no route table name, then use the default route table.  default route table to use defined in variable (var.default_route_table_name))    
#   route_table_id = data.azurerm_route_table[each.value].id
# }