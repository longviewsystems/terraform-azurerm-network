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
    
    create_route_table            = true
    route_table_name              = "default"
    disable_bgp_route_propagation = true
    routes=[
      #[route_name,address_prefix,next_hop_type,next_hop_in_ip_address]
      ["default","0.0.0.0/0","Internet",null],
      ["AzureFireWall","10.0.2.0/24","VnetLocal",null]
    ]
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
    
    create_route_table            = true
    route_table_name              = "default1"
    disable_bgp_route_propagation = true
    routes=[
      #[route_name,address_prefix,next_hop_type,next_hop_in_ip_address]
      ["default","0.0.0.0/0","Internet",null],
      ["AzureFireWall","10.0.2.0/24","VnetLocal",null]
    ]
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
    
    create_route_table            = false
    route_table_name              = "default2"
    disable_bgp_route_propagation = true
    routes=[
      #[route_name,address_prefix,next_hop_type,next_hop_in_ip_address]
      ["","","",null]
    ]
  }


}
