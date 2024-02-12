resource "random_string" "resource_name" {
  length  = 6  # length of the random string
  special = false  # special characters excluded in the random string
  upper   = false # in GCP, names must not include uppercase letters.
}

variable "webapp-internet-access" {
  type = string
}

variable "db-subnet-cidr" {
  type = string
}

variable "webapp-subnet-cidr" {
  type = string
}

variable "region" {
  type = string
}

variable "credentials_file_path" {
    type = string
}