output "subscriptions" {
  description = "Map (same keys as var.subscriptions) of every output from each subscription created -- see upstream module docs for the full shape."
  value       = module.subscription
}

output "subscription_ids" {
  description = "Map (same keys as var.subscriptions) of subscription IDs (bare GUIDs)."
  value       = { for k, v in module.subscription : k => v.subscription_id }
}

output "subscription_resource_ids" {
  description = "Map (same keys as var.subscriptions) of subscription resource IDs (`/subscriptions/<guid>`)."
  value       = { for k, v in module.subscription : k => v.subscription_resource_id }
}
