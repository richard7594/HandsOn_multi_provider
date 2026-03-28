terraform {

  required_version = ">= 1.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.37.0"
    }


  }

  backend "s3" {

    region       = "eu-west-1"
    bucket       = "handson-aws-group"
    key          = "state1/terraform.tfstate" # the previous state was corrupt
    use_lockfile = true
    encrypt      = true

  }
}