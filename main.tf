
locals {
  subnets_with_routes = { for subnet in var.subnets : subnet.name => subnet if !coalesce(subnet.disable_firewall_route, false) }
  subnets_map         = { for subnet in var.subnets : subnet.name => subnet }

  diag_vnet_metrics = [
    "AllMetrics",
  ]

