
variable "instance_type" {
  type = string
}
variable "vpc_cidr" {
  type = string
}

variable "pri_sub_cidr" {
  type = map(string)
}

variable "pub_sub_cidr" {
  type = string
}
variable "rds_sub_cidr" {
  type = map(string)

}
