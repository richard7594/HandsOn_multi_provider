provider "aws" {

  region = "eu-west-1"

  default_tags {
    tags = {
      Projet = "Hands_on_projet"
    }
  }
}

data "aws_secretsmanager_secret_version" "credentials" {
  secret_id = "credentials"
}

data "aws_lb" "nlb" {
  region = "eu-west-1"
  tags   = { Name = "NLB" }
  # depends_on = [module.vpc, module.ec2, module.rds]
}



#/etc/rancher/k3s/k3s.yaml

provider "kubernetes" {

  insecure               = true                                       # ==> curl -k 
  host                   = "https://${data.aws_lb.nlb.dns_name}:6443" #need to be pull directly from secret manager
  client_certificate     = base64decode(jsondecode(data.aws_secretsmanager_secret_version.credentials.secret_string)["client"])
  client_key             = base64decode(jsondecode(data.aws_secretsmanager_secret_version.credentials.secret_string)["key"])
  #cluster_ca_certificate = base64decode(jsondecode(data.aws_secretsmanager_secret_version.credentials.secret_string)["ca"])

}