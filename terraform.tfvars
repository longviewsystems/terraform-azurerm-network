resource_group_name = "vnet-nsg"
vnetwork_name       = "vnet-nsg-assc"
location            = "EastUS"
vnet_address_space  = ["10.1.0.0/16"]
dns_servers         = ["10.1.1.24"]


subnets = {
  mgnt_subnet = {
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

    route_table_name              = "route_table_default"


  }

  mgnt_subnet2 = {
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

    route_table_name              = "route_table_custom"
  }
  
  # To create a subnet without NSG Association.
  # Set create_nsg to false and set nsg_name to empty.
  mgnt_subnet3 = {
    subnet_name                                    = "subnet03"
    subnet_address_prefix                          = ["10.1.4.0/24"]
    create_nsg                                     = false
    nsg_name                                       = ""
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

    route_table_name              = ""
  }


}

route_tables = {
    route_table_default = { # key value for route table
      route_table_name              = "route_table_default"
      disable_bgp_route_propagation = true
      route_entries = {
        default_route1 = { # key value for routes
          route_name             = "default"
          address_prefix         = "10.0.2.0/24"
          next_hop_type          = "VnetLocal"
          next_hop_in_ip_address = null
        }
        default_route2 = { # key value for routes
          route_name             = "AzureFireWall"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.1.4.4"
        }
      }
    }
    route_table_custom = {
      route_table_name              = "route_table_custom"
      disable_bgp_route_propagation = true
      route_entries = {
        custom_route1 = {
          route_name             = "AzureFirewall"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.1.4.4"
        }
        custom_route2 = {
          route_name             = "custom"
          address_prefix         = "10.0.3.0/24"
          next_hop_type          = "VnetLocal"
          next_hop_in_ip_address = null
        }
      }
    }
  }
