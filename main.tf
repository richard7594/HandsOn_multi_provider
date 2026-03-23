module "vpc" {
  source = "./modules/vpc"

  vpc_cidr     = var.vpc_cidr
  pub_sub_cidr = var.pub_sub_cidr
  pri_sub_cidr = var.pri_sub_cidr
}

module "ec2" {
  source = "./modules/ec2"

  instance_type    = var.instance_type
  target_group_arn = module.vpc.target_group_arn
  instance_sg_id   = module.vpc.instance_sg_id
}

module "rds" {
  source = "./modules/rds"
}

module "kurbenetes" {
  source = "./modules/kubernetes"
}