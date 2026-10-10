variable "location" {
  description = "Default Azure region for every subscription-scoped resource (resource groups, virtual networks, identities, ...) created by this module call. Overridden per-subscription by that entry's own `location` attribute, if set."
  type        = string
}

variable "tags" {
  description = "Default tags applied to every subscription created by this module call (e.g. the output of terraform-azure-tags). Overridden per-subscription by that entry's own `tags` attribute, if set."
  type        = map(string)
  default     = {}
}

variable "enable_telemetry" {
  description = "Default AVM telemetry opt-in/out applied to every resource created by this module call. See https://aka.ms/avm/telemetry. Overridden per-resource by that resource's own `enable_telemetry` attribute, if set."
  type        = bool
  default     = true
}

variable "subscriptions" {
  description = "Map of subscriptions to create (or adopt), keyed by an arbitrary caller-chosen map key. Mirrors the inputs of Azure/avm-ptn-alz-sub-vending/azure v0.3.4 (https://registry.terraform.io/modules/Azure/avm-ptn-alz-sub-vending/azure/0.3.4) 1:1 -- see upstream docs for the schema of any field typed `any`. `location`, `tags` (upstream `subscription_tags`) and `enable_telemetry` are handled specially by this wrapper; every other field is passed straight through unmodified, with upstream's own defaults."
  type = map(object({
    location         = optional(string)
    tags             = optional(map(string))
    enable_telemetry = optional(bool)

    # Subscription
    subscription_alias_enabled                           = optional(bool, false)
    subscription_alias_name                              = optional(string, null)
    subscription_display_name                            = optional(string, null)
    subscription_billing_scope                           = optional(string, null)
    subscription_workload                                = optional(string, null)
    subscription_id                                      = optional(string, null)
    subscription_update_existing                         = optional(bool, false)
    subscription_management_group_association_enabled    = optional(bool, false)
    subscription_management_group_id                     = optional(string, null)
    wait_for_subscription_before_subscription_operations = optional(any, {})

    # Resource providers
    subscription_register_resource_providers_enabled      = optional(bool, false)
    subscription_register_resource_providers_and_features = optional(map(set(string)), null)

    # Role assignments
    role_assignment_enabled = optional(bool, false)
    role_assignments        = optional(any, null)

    # Budgets
    budget_enabled = optional(bool, false)
    budgets        = optional(any, {})

    # Resource groups
    resource_group_creation_enabled = optional(bool, false)
    resource_groups                 = optional(any, null)

    # User-assigned managed identities
    umi_enabled             = optional(bool, false)
    user_managed_identities = optional(any, {})

    # Networking
    virtual_network_enabled        = optional(bool, false)
    virtual_networks               = optional(any, null)
    network_security_group_enabled = optional(bool, false)
    network_security_groups        = optional(any, null)
    route_table_enabled            = optional(bool, false)
    route_tables                   = optional(any, null)
  }))
  default = {}
}
