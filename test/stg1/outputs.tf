output "fixture_resource_groups"  {
  description = "Resource Groups for vNets and other Resources."
  value = azurerm_resource_group.fixture
}

output "shared_services_resource_groups"  {
  description = "Resource Groups for Shared Resources."
  value = azurerm_resource_group.shared_services
}

output "shared_services_log_analytics_workspace_id" {
  description = "Log Analytics Resource ID."
  value = azurerm_log_analytics_workspace.shared_services.id
}

output "shared_services_azurerm_storage_account_name_id" {
  description = "Storage Account for Diagnostics Logging."
  value = azurerm_storage_account.shared_services.id
}

output "test3_azurerm_route_table" {
  description = "Route table for test 3."
  value = azurerm_route_table.route_table_test3_default
}

output "test3_azurerm_route_table_rg" {
  description = "Route table Resource Group for test 3."
  value = azurerm_resource_group.fixture["test3"]
}
