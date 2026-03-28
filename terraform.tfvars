instance_type = "t2.medium" #"t3.micro"
vpc_cidr      = "10.0.0.0/16"
pri_sub_cidr  = { "az1" = "10.0.1.0/24", "az2" = "10.0.3.0/24" }
pub_sub_cidr  = "10.0.2.0/24"