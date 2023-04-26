locals {
  subnets = {
    AzureFirewall = {
      subnet_name                                    = "AzureFirewall"
      subnet_address_prefix                          = ["10.1.2.0/24"]
      create_nsg                                     = true
      nsg_name                                       = "NSG-Subnet01"
      route_table_id                                 = "/subscriptions/57215661-2f9e-482f-9334-c092e02651ec/resourceGroups/mod-test1-rg-lqfs/providers/Microsoft.Network/routeTables/rt-test1-other"
      private_endpoint_network_policies_enabled      = true
      service_endpoints                              = ["Microsoft.Storage"]
      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["weballow", "100", "Inbound", "Allow", "Tcp", "80", "*", "0.0.0.0/0"],
        ["weballow1", "101", "Inbound", "Allow", "", "443", "*", ""],
        ["weballow2", "102", "Inbound", "Allow", "Tcp", "8080-8090", "*", ""],
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["ntp_out", "103", "Outbound", "Allow", "Udp", "123", "", "0.0.0.0/0"],
      ]
    }
    app_sn = {
      subnet_name                                    = "app_sn"
      subnet_address_prefix                          = ["10.1.2.0/24"]
      create_nsg                                     = true
      nsg_name                                       = "NSG-Subnet01"
      route_table_id                                 = "/subscriptions/57215661-2f9e-482f-9334-c092e02651ec/resourceGroups/mod-test1-rg-lqfs/providers/Microsoft.Network/routeTables/rt-test1-other"
      private_endpoint_network_policies_enabled      = true
      service_endpoints                              = ["Microsoft.Storage"]
      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["weballow", "100", "Inbound", "Allow", "Tcp", "80", "*", "0.0.0.0/0"],
        ["weballow1", "101", "Inbound", "Allow", "", "443", "*", ""],
        ["weballow2", "102", "Inbound", "Allow", "Tcp", "8080-8090", "*", ""],
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["ntp_out", "103", "Outbound", "Allow", "Udp", "123", "", "0.0.0.0/0"],
      ]
    }
  }
}

output "route_table_ids" {
  value = {
    for key, subnets in local.subnets : key => subnets
    if subnets.route_table_id != null && subnets.route_table_id != ""
  }
}

