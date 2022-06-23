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

resource "azurerm_monitor_diagnostic_setting" "vnet" {
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
}