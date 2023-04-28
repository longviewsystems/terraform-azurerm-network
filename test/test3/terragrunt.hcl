dependencies {
  paths = ["../stg1"]
}

dependency "existing_stg1_resources" {
  config_path  = "../stg1"
  skip_outputs = false
}

locals {
  test_name = "test3"
}

inputs = {
  resource_group_name        = dependency.existing_stg1_resources.outputs.fixture_resource_groups[local.test_name].name
  storage_account_id         = dependency.existing_stg1_resources.outputs.shared_services_azurerm_storage_account_name_id
  log_analytics_workspace_id = dependency.existing_stg1_resources.outputs.shared_services_log_analytics_resource_id
  log_analytics_resource_id  = dependency.existing_stg1_resources.outputs.shared_services_log_analytics_workspace_id
}
