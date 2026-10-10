module "subscription" {
  source   = "Azure/avm-ptn-alz-sub-vending/azure"
  version  = "0.3.4"
  for_each = var.subscriptions

  location          = coalesce(each.value.location, var.location)
  subscription_tags = coalesce(each.value.tags, var.tags)
  enable_telemetry  = coalesce(each.value.enable_telemetry, var.enable_telemetry)

  subscription_alias_enabled                           = each.value.subscription_alias_enabled
  subscription_alias_name                              = each.value.subscription_alias_name
  subscription_display_name                            = each.value.subscription_display_name
  subscription_billing_scope                           = each.value.subscription_billing_scope
  subscription_workload                                = each.value.subscription_workload
  subscription_id                                      = each.value.subscription_id
  subscription_update_existing                         = each.value.subscription_update_existing
  subscription_management_group_association_enabled    = each.value.subscription_management_group_association_enabled
  subscription_management_group_id                     = each.value.subscription_management_group_id
  wait_for_subscription_before_subscription_operations = each.value.wait_for_subscription_before_subscription_operations

  subscription_register_resource_providers_enabled      = each.value.subscription_register_resource_providers_enabled
  subscription_register_resource_providers_and_features = each.value.subscription_register_resource_providers_and_features

  role_assignment_enabled = each.value.role_assignment_enabled
  role_assignments        = each.value.role_assignments

  budget_enabled = each.value.budget_enabled
  budgets        = each.value.budgets

  resource_group_creation_enabled = each.value.resource_group_creation_enabled
  resource_groups                 = each.value.resource_groups

  umi_enabled             = each.value.umi_enabled
  user_managed_identities = each.value.user_managed_identities

  virtual_network_enabled        = each.value.virtual_network_enabled
  virtual_networks               = each.value.virtual_networks
  network_security_group_enabled = each.value.network_security_group_enabled
  network_security_groups        = each.value.network_security_groups
  route_table_enabled            = each.value.route_table_enabled
  route_tables                   = each.value.route_tables
}
