module "aim" {
    source =     "../aim"
    name        = var.name
    policy_arns = var.policy_arns
}