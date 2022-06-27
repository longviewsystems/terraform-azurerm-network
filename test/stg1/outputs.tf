output "fixture_resource_groups" {
  description = "Resource Groups for vNets and other Resources."
  value       = azurerm_resource_group.fixture
}

output "shared_services_resource_groups" {
  description = "Resource Groups for Shared Resources."
  value       = azurerm_resource_group.shared_services
}

output "shared_services_log_analytics_workspace_id" {
  description = "Log Analytics Resource ID."
  value       = azurerm_log_analytics_workspace.shared_services.id
}

output "shared_services_azurerm_storage_account_name_id" {
  description = "Storage Account for Diagnostics Logging."
  value       = azurerm_storage_account.shared_services.id
}

output "route_tables_test1" {
  description = "Route table for test 1."
  value       = module.test1_routes
}

output "route_tables_test2" {
  description = "Route table for test 2."
  value       = module.test2_routes
}
