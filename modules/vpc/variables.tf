variable "vpc_cidr" {
  type = string
}

variable "pri_sub_cidr" {
  type = map(string)
}

variable "pub_sub_cidr" {
  type = map(string)
}

variable "az" {
  type = map(string)
  default = {
    "az1" = "eu-west-1a",
    "az2" = "eu-west-1b"
  }
}

variable "launch_template" {
  type = string
}

variable "rds_sub_cidr" {
  type = map(string)

}
variable "instance_id" {
  type = string
}