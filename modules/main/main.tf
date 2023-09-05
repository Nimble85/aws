module "aim" {
    source =     "../aim"
    count = 0
    name        = var.name
    policy_arns = var.policy_arns
}

module "network" {
    source =     "../network"
    region = var.region
    vpc_cidr = var.vpc_cidr
    subnet_cidr = var.subnet_cidr
}