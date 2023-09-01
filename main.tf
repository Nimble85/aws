module "env" {
    source = "./modules/main"
    name   = var.name
    policy_arns = var.policy_arns
}