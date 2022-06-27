dependencies {
  paths = ["../stg1"]
}

dependency "existing_stg1_resources" {
  config_path  = "../stg1"
  skip_outputs = false
}

locals {
  test_name = "test2"
}

inputs = {
  resource_group_name        = dependency.existing_stg1_resources.outputs.fixture_resource_groups[local.test_name].name
  storage_account_id         = dependency.existing_stg1_resources.outputs.shared_services_azurerm_storage_account_name_id
  log_analytics_workspace_id = dependency.existing_stg1_resources.outputs.shared_services_log_analytics_workspace_id
  route_table1 = {
    route_table_rg_name = dependency.existing_stg1_resources.outputs.route_tables_test2.route_tables_object.route_table_custom.resource_group_name
    route_table_name    = dependency.existing_stg1_resources.outputs.route_tables_test2.route_tables_object.route_table_custom.name
  }
  route_table2 = {
    route_table_rg_name = dependency.existing_stg1_resources.outputs.route_tables_test2.route_tables_object.route_table_default.resource_group_name
    route_table_name    = dependency.existing_stg1_resources.outputs.route_tables_test2.route_tables_object.route_table_default.name
  }
}
