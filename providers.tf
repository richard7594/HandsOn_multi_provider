provider "aws" {
  region = "eu-west-1"

}

# to be complete
provider "kubernetes" {
  alias = "k3s"

}