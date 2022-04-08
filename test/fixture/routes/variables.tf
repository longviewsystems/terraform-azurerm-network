variable "resource_group_name" {
  type        = string
  description = "The name of the Resource group"
  default     = "rg-demo-westeurope-01"
}

variable "location" {
  type        = string
  description = "The Location where RG is created"
  default     = "westeurope"
}

variable "tags" {
  type        = map(any)
  description = "Resource tags"
  default = {
    environment = "test"
    managed_by  = "terratest"
  }
}

variable "route_tables" {
  description = "Create Route Tables with routes"
  type = map(object({
    route_table_name              = string
    disable_bgp_route_propagation = string
    route_entries = map(object({
      route_name             = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
    }))
  }))
  default = {
route_table_default = { # key value for route table
    route_table_name              = "default"
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
        next_hop_type          = "Internet"
        next_hop_in_ip_address = null
      }
    }
  }
  route_table_custom = {
    route_table_name              = "custom"
    disable_bgp_route_propagation = true
    route_entries = {
      custom_route1 = {
        route_name             = "custom"
        address_prefix         = "10.0.0.16/28"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.0.10"
      }
      custom_route2 = {
        route_name             = "AzureFireWall"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "Internet"
        next_hop_in_ip_address = null
      }
    }
  }
}
}