module "network_test2" {
  source              = "../../"
  resource_group_name = var.resource_group_name
  vnetwork_name       = "vnet-nsg-assc3"
  location            = var.location
  vnet_address_space  = ["10.1.0.0/16"]
  dns_servers         = ["10.1.1.24"]

  #test with la only
  diagnostic_settings = {
    diagnostics_enabled        = true
    storage_account_id         = var.storage_account_id
    log_analytics_workspace_id = var.log_analytics_workspace_id
    nsg_diag_logs              = ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
    retention_policy           = 90
  }

  subnets = {
    app-gw = {
      subnet_name                                    = "snet-appgw-01"
      subnet_address_prefix                          = ["10.1.2.0/24"]
      create_nsg                                     = true
      nsg_name                                       = "nsg-appgw-01"
      route_table_rg_name =  var.route_table1.route_table_rg_name
      route_table_name =  var.route_table1.route_table_name
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
    }
    subnet3 = {
      subnet_name                                    = "subnet03"
      subnet_address_prefix                          = ["10.1.4.0/24"]
      create_nsg                                     = false
      nsg_name                                       = "NSG-subnet03"
      route_table_rg_name =  var.route_table2.route_table_rg_name
      route_table_name =  var.route_table2.route_table_name
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
    }
  }
}