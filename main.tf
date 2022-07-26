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
  enforce_private_link_endpoint_network_policies = lookup(each.value, "enforce_private_link_endpoint_network_policies", null)
  service_endpoint_policy_ids                    = null

}

#-----------------------------------------------
#          Route Tables 
#-----------------------------------------------

#data lookup -> route id -> exists already

resource "azurerm_subnet_route_table_association" "routetable" {
  for_each       = local.route_table_list
  subnet_id      = azurerm_subnet.snet[each.key].id
  route_table_id = data.azurerm_route_table.routetable[each.key].id
}

#-----------------------------------------------
#          Diagnostic Settings
#-----------------------------------------------

/*resource "azurerm_monitor_diagnostic_setting" "vnet" {
  #if var.diagnostic_settings.diagnostics_enabled, then turn on diagnostics. pass empty map which will create no diagnistics settings
  count                      = var.diagnostic_settings.diagnostics_enabled ? 1 : 0
  name                       = lower("${azurerm_virtual_network.vnet.name}-diag")
  target_resource_id         = azurerm_virtual_network.vnet.id
  storage_account_id         = var.diagnostic_settings.storage_account_id
  log_analytics_workspace_id = var.diagnostic_settings.log_analytics_workspace_id

  log {
    category = "VMProtectionAlerts"
    enabled  = true

    retention_policy {
      enabled = true
      days    = var.diagnostic_settings.retention_policy
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = var.diagnostic_settings.retention_policy
    }
  }
}*/

#-----------------------------------------------
#          Network Watcher
#-----------------------------------------------

/*resource "azurerm_network_watcher" "nwatcher" {
  count               = var.create_network_watcher != false ? 1 : 0
  name                = "NetworkWatcher_${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                =  var.tags
}*/

data "azurerm_network_watcher" "nwatcher" {
  name                = "NetworkWatcher_${var.location}"
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_watcher_flow_log" "nsg" {
  for_each = {
    for name, subnets in var.subnets : name => subnets
    if subnets.create_flow_logs == true
  }
  name     = lower("${each.key}-nsg-flow-log") #db-snet-nsg-net-dev1-usw2-rg-flowlog

  network_watcher_name = data.azurerm_network_watcher.nwatcher.name
  resource_group_name  = var.resource_group_name

  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
  storage_account_id        = var.storage_account_id
  enabled                   = true
  version                   = "2"

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.log_analytics_workspace_id//wksp id
    workspace_region      = var.location
    workspace_resource_id = var.log_analytics_resource_id //LA id
    interval_in_minutes   = 10
  }
   depends_on = [data.azurerm_network_watcher.nwatcher]
}

