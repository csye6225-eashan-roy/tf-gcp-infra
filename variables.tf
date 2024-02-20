resource "random_string" "resource_name" {
  length  = 6     # length of the random string
  special = false # special characters excluded in the random string
  upper   = false # in GCP, names must not include uppercase letters.
}

variable "webapp-internet-access" {
  type = string
}

variable "db-subnet-cidr" {
  type = string
}

variable "routing-mode" {
  type = string
}

variable "webapp-subnet-cidr" {
  type = string
}

variable "region" {
  type = string
}

# variable "credentials_file_path" {
#     type = string
# }

variable "protocol" {
  type    = string
}

variable "port-https" {
  type    = string
}

variable "port-http" {
  type = string
}

variable "port-ssh" {
  type = string
}

# variable "ports" {
#   type    = list(string)
#   default = ["80", "443", "22"] // HTTP and HTTPS
# }

variable "source_ranges" {
  description = "CIDR IP ranges that are allowed or denied"
  type        = list(string)
}

