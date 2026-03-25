provider "aws" {

  region = "eu-west-1"
  access_key = "${AWS_ACCESS_KEY_ID}"
  secret_key = "${AWS_SECRET_ACCESS_KEY}"
  
  # we have to give a role 

  default_tags {
    tags = {
      Projet = "Hands_on_projet"
    }
  }
}

# to be complete
provider "kubernetes" {
  alias = "k3s"

}