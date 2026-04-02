
locals {
  bucket_arn = "${aws_s3_bucket.s3.arn}/*"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = var.vpc_cidr
  pub_sub_cidr    = var.pub_sub_cidr
  pri_sub_cidr    = var.pri_sub_cidr
  rds_sub_cidr    = var.rds_sub_cidr
  launch_template = module.ec2.launch_template
  instance_id     = module.ec2.instance_id
}


module "ec2" {
  source = "./modules/ec2"

  instance_type  = var.instance_type
  instance_sg_id = module.vpc.instance_sg_id
  subnet_id      = module.vpc.pri_sub_id1 #instance in the private subnet
  vpc_id         = module.vpc.vpc_id
  pub_sub_id     = module.vpc.pub_sub_id1  #Need for bastion debbug so you can remove, not useful now
  ami            = "ami-0428ac7f9776f14c3" # move to .tfvars
  bucket_arn     = local.bucket_arn
}

module "rds" {
  source      = "./modules/rds"
  rds_sub_id1 = module.vpc.rds_sub_id1
  rds_sub_id2 = module.vpc.rds_sub_id2
  rds_sg_id   = module.vpc.rds_sg_id
}

module "kurbenetes" {
  source = "./modules/kubernetes"
}

