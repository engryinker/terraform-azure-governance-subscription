# terraform-azure-governance-subscription

Org-standard Terraform wrapper for: **subscriptions** (subscription vending).

Wraps the AVM subscription-vending pattern module, which creates a subscription alias (or adopts an existing subscription), places it in a management group, and can optionally register resource providers and create role assignments, budgets, resource groups, user-assigned identities and networking inside it. There is no AVM *resource* module for subscriptions; this pattern module is Microsoft's supported path.

Compose with [terraform-azure-governance-managementgroup](https://github.com/engryinker/terraform-azure-governance-managementgroup) (its `management_group_names` output feeds `subscription_management_group_id`) and [terraform-azure-tags](https://github.com/engryinker/terraform-azure-tags) for the `tags` input.

**Prerequisites**

- Creating a subscription alias needs a billing role on `subscription_billing_scope` (e.g. *Enrollment account subscription creator* for EA, *Azure subscription creator* on the invoice section for MCA).
- Placing it in a management group needs *Management Group Contributor* (or Owner) on the target group.
- Upstream tries to delete the `NetworkWatcherRG` resource group via `az cli` when a subscription is destroyed, so `az` must be installed and logged in wherever `terraform destroy` runs.
- Requires Terraform >= 1.10 (upstream constraint).

**Overlap with other repos:** The `resource_groups`, `virtual_networks`, `network_security_groups` and `route_tables` features duplicate `terraform-azure-governance-resourcegroup` and the `network-*` repos. They exist so a subscription can be vended with its baseline already in place. For anything beyond that baseline, leave them disabled and use the dedicated repos instead.

## Usage

```hcl
module "governance-subscription" {
  source = "git::https://github.com/engryinker/terraform-azure-governance-subscription.git?ref=v1.0.0"

  location = "eastus"
  tags     = module.tags.tags

  subscriptions = {
    corp_app1_prod = {
      subscription_alias_enabled = true
      subscription_alias_name    = "sub-corp-app1-prod"
      subscription_display_name  = "Corp - App1 - Prod"
      subscription_billing_scope = "/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456"
      subscription_workload      = "Production"

      subscription_management_group_association_enabled = true
      subscription_management_group_id                  = module.governance-managementgroup.management_group_names["corp"]
    }

    # Adopt an existing subscription instead of creating one
    legacy = {
      subscription_id                                   = "00000000-0000-0000-0000-000000000000"
      subscription_management_group_association_enabled = true
      subscription_management_group_id                  = "mg-contoso-corp"
    }
  }
}
```

See [`examples/basic`](examples/basic) for a minimal runnable (zero-instance) example.

## Inputs

Beyond the standard `location`, `tags`, `enable_telemetry` module-level variables, the map variable below mirrors its upstream AVM module's inputs 1:1, with the exact upstream types (see the linked module docs for nested schemas). Every field is optional and defaults to upstream's own default.

### `subscriptions` (subscriptions)

Wraps [Azure/avm-ptn-alz-sub-vending/azure](https://registry.terraform.io/modules/Azure/avm-ptn-alz-sub-vending/azure/0.3.4) v0.3.4.

| Field | Type | Notes |
| --- | --- | --- |
| `subscription_alias_enabled` | `bool` | Create a new subscription alias. |
| `subscription_alias_name` | `string` | Alias resource name (immutable). |
| `subscription_display_name` | `string` |  |
| `subscription_billing_scope` | `string` | `/providers/Microsoft.Billing/billingAccounts/...` (EA, MCA or MPA scope). |
| `subscription_workload` | `string` | `Production` or `DevTest`. |
| `subscription_id` | `string` | Existing subscription GUID to adopt instead of creating an alias. |
| `subscription_update_existing` | `bool` | Update display name / tags of an existing `subscription_id`. |
| `subscription_management_group_association_enabled` | `bool` |  |
| `subscription_management_group_id` | `string` | Bare management group ID (name), **not** the full resource ID. |
| `wait_for_subscription_before_subscription_operations` | `object` | `{ create = "30s", destroy = "0s" }` |
| `subscription_register_resource_providers_enabled` | `bool` |  |
| `subscription_register_resource_providers_and_features` | `map(set(string))` | Defaults to upstream's built-in provider list. |
| `role_assignment_enabled` | `bool` |  |
| `role_assignments` | `map(object)` |  |
| `budget_enabled` | `bool` |  |
| `budgets` | `map(object)` |  |
| `resource_group_creation_enabled` | `bool` |  |
| `resource_groups` | `map(object)` |  |
| `umi_enabled` | `bool` |  |
| `user_managed_identities` | `map(object)` |  |
| `virtual_network_enabled` | `bool` |  |
| `virtual_networks` | `map(object)` |  |
| `network_security_group_enabled` | `bool` |  |
| `network_security_groups` | `map(object)` |  |
| `route_table_enabled` | `bool` |  |
| `route_tables` | `map(object)` |  |
| `location` | `string` | Overrides the module-level `location` for this entry only. |
| `tags` | `map(string)` | Subscription tags (upstream `subscription_tags`). Overrides the module-level `tags` for this entry only. |
| `enable_telemetry` | `bool` | Overrides the module-level `enable_telemetry` for this entry only. |

## Outputs

- `subscriptions` -- map (same keys as the input) of every output from each created subscription.
- `subscription_ids` -- map (same keys as the input) of subscription IDs (bare GUIDs).
- `subscription_resource_ids` -- map (same keys as the input) of subscription resource IDs (`/subscriptions/<guid>`).
