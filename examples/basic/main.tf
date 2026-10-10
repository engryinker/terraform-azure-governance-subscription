terraform {
  required_version = ">= 1.10.0"
}

module "governance-subscription" {
  source = "../.."

  location = "eastus"
  tags = {
    environment = "dev"
  }

  subscriptions = {} # see README Inputs table / upstream module docs for the per-entry schema
}
