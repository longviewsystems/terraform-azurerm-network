resource_group_name = "vnetrg"

locations = {
  "primary_location"   = "canadacentral",
  "secondary_location" = "canadaeast"
}

tags = {
  environment = "test",
  managedBy   = "Terraform",
}
vnet_name       = "testvnet"
address_space   = ["10.0.0.0/16", "10.2.0.0/16"]
dns_servers     = ["8.8.8.8", "8.8.4.4"]
subnet_prefixes = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
subnet_names    = ["subnet1", "subnet2", "subnet3"]
subnet_service_endpoints = {
  "subnet1" : ["Microsoft.AzureActiveDirectory"],
  "subnet2" : ["Microsoft.Storage"],
  "subnet3" : ["Microsoft.Sql"]
}