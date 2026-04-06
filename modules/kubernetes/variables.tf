variable "image" {
  type    = string
  default = "wordpress:php8.2"
  # default = "nginx:alpine"
}

variable "secret_id" {
  type = string

}

variable "rds_dns_name" {
  type = string
}

variable "db_name" {
  type = string
}