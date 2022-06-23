module "network_test1" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.fixture["test1"].name
  vnetwork_name       = "vnet-nsg-assc1"
  location            = "EastUS"
  vnet_address_space  = ["10.1.0.0/16"]
  dns_servers         = ["10.1.1.24"]

  # test default value.
  # diagnostic_settings 

  subnets = {
    subnet = {
      subnet_name                                    = "subnet01"
      subnet_address_prefix                          = ["10.1.2.0/24"]
      create_nsg                                     = true
      nsg_name                                       = "NSG-Subnet01"
      enforce_private_link_endpoint_network_policies = true
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

      create_route_table            = true
      route_table_name              = "default"
      disable_bgp_route_propagation = true
      routes = [
        #[route_name,address_prefix,next_hop_type,next_hop_in_ip_address]
        ["default", "0.0.0.0/0", "VirtualAppliance", "10.1.4.4"],
      ]
    }

  }
}

module "network_test2" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.fixture["test2"].name
  vnetwork_name       = "vnet-nsg-assc2"
  location            = "EastUS"
  vnet_address_space  = ["10.1.0.0/16"]
  dns_servers         = ["10.1.1.24"]

  #test with la only
  diagnostic_settings = {
    diagnostics_enabled        = true
    storage_account_id         = null
    log_analytics_workspace_id = azurerm_log_analytics_workspace.shared_services.id
    nsg_diag_logs              = ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
    retention_policy           = 0
  }

  subnets = {

    subnet2 = {
      subnet_name                                    = "subnet02"
      subnet_address_prefix                          = ["10.1.3.0/24"]
      create_nsg                                     = true
      nsg_name                                       = "NSG-Subnet02"
      service_endpoints                              = ["Microsoft.Sql"]
      enforce_private_link_endpoint_network_policies = true
      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["weballow", "100", "Inbound", "Allow", "Tcp", "80", "*", "0.0.0.0/0"],
        ["weballow1", "101", "Inbound", "Allow", "", "443", "*", ""]
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["ntp_out", "103", "Outbound", "Allow", "Udp", "123", "", "0.0.0.0/0"],
      ]

      create_route_table            = true
      route_table_name              = "default01"
      disable_bgp_route_propagation = true
      routes = [
        #[route_name,address_prefix,next_hop_type,next_hop_in_ip_address]
        ["default", "0.0.0.0/0", "VirtualAppliance", "10.1.4.4"],
      ]
    }
  }
}
module "network_test3" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.fixture["test3"].name
  vnetwork_name       = "vnet-nsg-assc3"
  location            = "Westus2"
  vnet_address_space  = ["10.1.0.0/16"]
  dns_servers         = ["10.1.1.24"]

  #test with la only
  diagnostic_settings = {
    diagnostics_enabled        = true
    storage_account_id         = azurerm_storage_account.shared_services.id
    log_analytics_workspace_id = azurerm_log_analytics_workspace.shared_services.id
    nsg_diag_logs              = ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
    retention_policy           = 90
  }

  subnets = {
    subnet2 = {
      subnet_name                                    = "subnet02"
      subnet_address_prefix                          = ["10.1.3.0/24"]
      create_nsg                                     = true
      nsg_name                                       = "NSG-Subnet02"
      service_endpoints                              = ["Microsoft.Sql", "Microsoft.Storage"]
      enforce_private_link_endpoint_network_policies = true
      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["weballow", "100", "Inbound", "Allow", "Tcp", "80", "*", "0.0.0.0/0"],
        ["weballow1", "101", "Inbound", "Allow", "", "443", "*", ""]
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["ntp_out", "103", "Outbound", "Allow", "Udp", "123", "", "0.0.0.0/0"],
      ]

      create_route_table            = true
      route_table_name              = "default01"
      disable_bgp_route_propagation = true
      routes = [
        #[route_name,address_prefix,next_hop_type,next_hop_in_ip_address]
        ["default", "0.0.0.0/0", "VirtualAppliance", "10.1.4.4"],
      ]
    }
    subnet3 = {
      subnet_name                                    = "subnet03"
      subnet_address_prefix                          = ["10.1.4.0/24"]
      create_nsg                                     = false
      nsg_name                                       = "NSG-subnet03"
      service_endpoints                              = ["Microsoft.Sql"]
      enforce_private_link_endpoint_network_policies = true
      nsg_inbound_rules = [

        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]

        # To use defaults, use "" without adding any values.

        ["", "", "", "", "", "", "", ""],

      ]

      nsg_outbound_rules = [

        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]

        # To use defaults, use "" without adding any values.

        ["", "", "", "", "", "", "", ""],

      ]

      create_route_table            = true
      route_table_name              = "default02"
      disable_bgp_route_propagation = true
      routes = [
        #[route_name,address_prefix,next_hop_type,next_hop_in_ip_address]
        ["default", "0.0.0.0/0", "VirtualAppliance", "10.1.4.4"],
      ]
    }
  }
}
