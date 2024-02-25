##############################################################

#       RANDOM STRING TO BE USED IN RESOURCE NAMES

##############################################################

resource "random_string" "resource_name" {
  length  = 6     # length of the random string
  special = false # special characters excluded in the random string
  upper   = false # in GCP, names must not include uppercase letters.
}


##############################################################

#                    VARIABLES - PROVIDER

##############################################################

variable "project-id" {
  type = string
}

variable "provider-region" {
  type = string
}


##############################################################

#                   VARIABLES - VPC

##############################################################

variable "vpc-webapp-internet-access" {
  type = string
}

variable "vpc-db-subnet-cidr" {
  type = string
}

variable "vpc-routing-mode" {
  type = string
}

variable "vpc-webapp-subnet-cidr" {
  type = string
}

variable "vpc-region" {
  type = string
}

variable "protocol" {
  type = string
}

variable "port-https" {
  type = string
}

variable "port-http" {
  type = string
}

variable "port-8081" {
  type = string
}

variable "source_ranges" {
  description = "CIDR IP ranges that are allowed or denied"
  type        = list(string)
}

variable "vpc-auto-create-subnets" {
  type = bool
}

variable "vpc-delete-default-routes" {
  type = bool
}

variable "vpc-next-hop-gateway" {
  type = string
}

variable "firewall-allow-https-tag" {
  type = string
}

variable "firewall-allow-http-tag" {
  type = string
}

variable "firewall-allow-8081-tag" {
  type = string
}

variable "firewall-deny-http-tag" {
  type = string
}

variable "firewall-deny-https-tag" {
  type = string
}


##############################################################

#                    VARIABLES - VM

##############################################################

variable "vm-name" {
  type = string
}

variable "vm-size" {
  type = string
}

variable "vm-zone" {
  type = string
}

variable "packer-image-path" {
  type = string
}

variable "service-account-email" {
  type = string
}

variable "service-account-scope" {
  type = string
}

variable "vm-tags" {
  type = list(string)
}

variable "vm-can-ip-forward" {
  type = bool
}

variable "vm-deletion-protection" {
  type = bool
}

variable "vm-storage" {
  type = string
}

variable "vm-type" {
  type = string
}


##############################################################

#                    VARIABLES - Database

##############################################################


variable "db-version" {
  type = string
}

variable "db-tier" {
  type = string
}

variable "db-deletion-protection" {
  type = bool
}

variable "db-availability-type" {
  type = string
}

variable "db-disk-type" {
  type = string
}

variable "db-disk-size" {
  type = string
}