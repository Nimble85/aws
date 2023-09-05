module "aim" {
    source =     "../aim"
    count = 0
    name        = var.name
    policy_arns = var.policy_arns
}

module "network" {
    source =     "../network"
    count = 0
    region = var.region
    vpc_cidr = var.vpc_cidr
    subnet_cidr = var.subnet_cidr
}

module "s3buckets" {
    source = "../s3buckets"
}