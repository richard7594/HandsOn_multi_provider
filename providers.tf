provider "aws" {

  region = "eu-west-1"

  default_tags {
    tags = {
      Projet = "Hands_on_projet"
    }
  }
}

# to be complete
provider "kubernetes" {
  

}