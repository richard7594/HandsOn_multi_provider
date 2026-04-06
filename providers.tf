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

# data "aws_lb" "nlb" {
#   region = "eu-west-1"
#   tags   = { Name = "NLB" }
#   depends_on = [module.vpc, module.ec2, module.rds]
# }



#/etc/rancher/k3s/k3s.yaml

# worflow :
#-  terraform plan -out=myplan -target=module.vpc -target=module.ec2 -target=module.rds      ==> to ensure that the dns name to initiale kubernetes providers is available
#-  terraform apply "myplan"
#-  terraform plan -out=myplan -target=module.kubernetes ==> if possible, we can implement an interval of x min before to launch this in the pipeline
#-  terraform apply "myplan"

provider "kubernetes" {

  insecure           = true # ==> curl -k 
  host               = "https://${module.vpc.nlb_dns_name}:6443"
  client_certificate = base64decode(jsondecode(data.aws_secretsmanager_secret_version.credentials.secret_string)["client"])
  client_key         = base64decode(jsondecode(data.aws_secretsmanager_secret_version.credentials.secret_string)["key"])
  #cluster_ca_certificate = base64decode(jsondecode(data.aws_secretsmanager_secret_version.credentials.secret_string)["ca"])

}
