module "env" {
    source = "./modules/main"
    name   = var.name
    policy_arns = var.policy_arns
    # network
    region = var.region
    ### NETWORK Module ###
    vpc_cidr = var.vpc_cidr
    subnet_cidr = var.subnet_cidr

}