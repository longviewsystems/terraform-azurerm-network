module "network_test3" {
  source              = "../../"
  resource_group_name = var.resource_group_name
  nw_resource_group_name = var.nw_resource_group_name
  vnetwork_name       = "vnet-nsg-assc3"
  location            = var.location
  vnet_address_space  = ["10.1.0.0/16"]
  dns_servers         = ["10.1.1.24"]
  storage_account_id  = var.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  log_analytics_resource_id = var.log_analytics_resource_id
  network_watcher_name = var.network_watcher_name
  create_network_watcher  = true
  //la_storage_account_name = var.la_storage_account_name

  subnets = {
    app-gw = {
      subnet_name                                    = "snet-appgw-01"
      subnet_address_prefix                          = ["10.1.2.0/24"]
      create_nsg                                     = true
      create_flow_logs                               = true
      nsg_name                                       = "nsg-appgw-01"
      service_endpoints                              = ["Microsoft.Sql", "Microsoft.Storage"]
      route_table_id                                 = each.value.route_table_id
      add_route                                      = true
      private_endpoint_network_policies_enabled      = true
      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["AllowAccessToGWM_ProbePorts","110","Inbound","Allow","Tcp","65200-65535","GatewayManager","*"],
        ["AllowAccessToInternet_Https","910","Inbound","Allow","Tcp","","AzureLoadBalancer","*"],
        ["AllowAccessToAzureLoadBalancer","920","Inbound","Allow","Tcp","443","Internet","*"],
        ["DenyAllInternetInbound","4096","Inbound","Deny","*","","Internet","*"]
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["Allow_All", "100", "Outbound", "Allow", "*", "*", "", "*"]
      ]
    }
    app-web = {
      subnet_name                                    = "snet-appweb-01"
      subnet_address_prefix                          = ["10.1.3.0/24"]
      create_nsg                                     = true
      create_flow_logs                               = true
      nsg_name                                       = "nsg-appweb-01"
      service_endpoints                              = []
      route_table_id                                 = each.value.route_table_id
      add_route                                      = true
      private_endpoint_network_policies_enabled      = true
      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["Allow_HTTPS", "100", "Inbound", "Allow", "Tcp", "443", "*", "*"],
        ["Allow_HTTP", "110", "Inbound", "Allow", "Tcp", "80", "*", ""],
        ["Deny_All", "4096", "Inbound", "Deny", "*", "*", "", "*"],
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["Allow_All", "100", "Outbound", "Allow", "*", "*", "", "*"]
      ]
    }    
    snet-db-01 = {
      subnet_name                                    = "snet-db-01"
      subnet_address_prefix                          = ["10.1.4.0/24"]
      create_nsg                                     = false
      create_flow_logs                               = false
      nsg_name                                       = "snet-db-01-nsg"
      service_endpoints                              = ["Microsoft.Sql"]
      route_table_id                                 = each.value.route_table_id
      add_route                                      = true
      private_endpoint_network_policies_enabled      = true
      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["Allow_MI_Subnet","100","Inbound","Allow","*","*","10.100.3.128/26","*"],          
        ["Allow_MI_Mgmt","200","Inbound","Allow","Tcp","9000, 9003, 1438, 1440, 1452","SqlManagement","*"],
        ["Allow_MI_Mgmt2","300","Inbound","Allow","Tcp","9000, 9003","CorpnetSaw","*"],
        ["Allow_MI_Mgmt3","400","Inbound","Allow","Tcp","9000, 9003","CorpnetPublic","*"],
        ["Allow_MI_Health_Probe","500","Inbound","Allow","Tcp","*","AzureLoadBalancer","*"],
        ["Deny_All_Internet_Inbound","4096","Inbound","Deny","*","","Internet","*"]
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["Allow_MI_Mgmt_Outbound", "110", "Outbound", "Allow", "Tcp", "*", "*", "AzureCloud"],
        ["Deny_All_Internet_Outbound","4096","Outbound","Deny","*","","Internet","*"]
      ]
    }
  }
}
