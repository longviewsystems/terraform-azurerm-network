#-------------------------------------
# VNET Creation - Default is "true"
#-------------------------------------

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnetwork_name
  location            = var.location
  resource_group_name = var.resource_group_name
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
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = each.value.subnet_address_prefix
  service_endpoints                              = lookup(each.value, "service_endpoints", [])
  private_endpoint_network_policies_enabled      = lookup(each.value, "private_endpoint_network_policies_enabled", null)
  service_endpoint_policy_ids                    = null

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", {}) != {} ? [1] : []
    content {
      name = lookup(each.value.delegation, "name", null)
      service_delegation {
        name    = lookup(each.value.delegation.service_delegation, "name", null)
        actions = lookup(each.value.delegation.service_delegation, "actions", null)
      }
    }
  }
}

#-----------------------------------------------
#          Route Tables 
#-----------------------------------------------


resource "azurerm_subnet_route_table_association" "routetable" {
  for_each = {
    for name, subnets in var.subnets : name => subnets
    if subnets.add_route == true
  }
  subnet_id      = azurerm_subnet.snet[each.key].id
  route_table_id = each.value.route_table_id
}

data "azurerm_network_watcher" "nwatcher" {
  count               = var.create_network_watcher != false ? 1 : 0
  name                = var.network_watcher_name
  resource_group_name = var.nw_resource_group_name
}

resource "azurerm_network_watcher_flow_log" "nsg" {
  for_each = {
    for name, subnets in var.subnets : name => subnets
    if subnets.create_flow_logs == true
  }
  name     = lower("${azurerm_virtual_network.vnet.name}-${each.value.subnet_name}-log")

  network_watcher_name = var.network_watcher_name
  resource_group_name  = var.nw_resource_group_name

  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
  storage_account_id        = var.storage_account_id
  enabled                   = true
  version                   = "2"

  retention_policy {
    enabled = true
    days    = 90
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.log_analytics_workspace_id //wksp id
    workspace_region      = var.log_analytics_location == "" ? var.location : var.log_analytics_location
    workspace_resource_id = var.log_analytics_resource_id //LA id
    interval_in_minutes   = 10
  }
   depends_on = [data.azurerm_network_watcher.nwatcher]
}

