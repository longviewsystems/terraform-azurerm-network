name                = "Test-Vnet"
resource_group_name = "Test-RG"
locations = {
  "primary_location"   = "canadacentral",
  "secondary_location" = "canadaeast"
}

address_space = "10.0.0.0/16"

firewall_ip = "10.0.1.1/24"
subnets     = "10.0.1.0/24"
tags = {
  environment = "Dev",
  costCenter  = "",
  managedBy   = "Terraform",
  owner       = "",
  TFLevel     = "L2"
}
