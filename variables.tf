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

variable "deny_all_source_ranges" {
  description = "CIDR IP ranges that are allowed or denied"
  type        = list(string)
}

variable "alb-source-ranges" {
  description = "CIDR IP ranges for ALB health checks"
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

variable "firewall-tag-allow-https-to-vm-from-alb" {
  type = string
}

variable "firewall-tag-allow-http-to-vm-from-alb" {
  type = string
}

variable "firewall-tag-allow-8081-to-vm-from-alb" {
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

variable "service-account-scope-vm" {
  type = list(string)
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

variable "db-availability-type" {
  type = string
}

variable "db-disk-type" {
  type = string
}

variable "db-disk-size" {
  type = string
}


##############################################################

#                    VARIABLES - SERVICE ACCOUNT FOR VM

##############################################################

variable "service_account_id" {}
variable "service_account_display_name" {}
variable "logging_admin_role" {}
variable "monitoring_metric_writer_role" {}


##############################################################

#                    VARIABLES - DNS

##############################################################


variable "dns_name" {}
variable "dns_type" {}
variable "dns_ttl" {}
variable "managed_zone" {}


##############################################################

#                    VARIABLES - PUB/SUB

##############################################################

variable "message_storage_region" {}
variable "pubsub_topic_name" {}
variable "message_retention_duration" {}
variable "pubsub_subscription_name" {}
variable "ack_deadline_seconds" {}

##############################################################

#                    VARIABLES - Cloud Function

##############################################################

variable "cloud_function_available_memory" {}
variable "cloud_function_timeout_seconds" {}

##############################################################

#                    VARIABLES - VPC Access Connector

##############################################################

variable "vpc_access_connector_ip_cidr_range" {}


##############################################################

#                    VARIABLES - VM template

##############################################################
variable "disk_auto_delete" {
  description = "Indicates whether the disk is auto-deleted when the instance is deleted."
  type        = bool
}

variable "disk_boot" {
  description = "Indicates whether this is a boot disk."
  type        = bool
}

variable "automatic_restart" {
  description = "Indicates whether the instance should be automatically restarted if it is terminated by Compute Engine (not terminated by the user)."
  type        = bool
}

variable "on_host_maintenance" {
  description = "Defines the maintenance behavior of the instance. Can be MIGRATE or TERMINATE."
  type        = string
}

variable "preemptible" {
  description = "Indicates if the instance is preemptible."
  type        = bool
}

##############################################################

#                    VARIABLES - Health check

##############################################################

variable "check_interval_sec" {
  description = "How often (in seconds) to perform a health check."
  type        = number
}

variable "health_check_timeout_sec" {
  description = "How long (in seconds) to wait for a response before considering the health check failed."
  type        = number
}

variable "healthy_threshold" {
  description = "Number of consecutive successful checks required to mark an unhealthy instance as healthy again."
  type        = number
}

variable "unhealthy_threshold" {
  description = "Number of consecutive failed checks required to mark a healthy instance as unhealthy."
  type        = number
}

##############################################################

#                   VARIABLES - MIG and Autoscaler

##############################################################

variable "mig_base_instance_name" {
  description = "Base name for instances created in the managed instance group"
  type        = string
}

variable "distribution_policy_zones" {
  description = "Zones for distributing instances in the managed instance group"
  type        = list(string)
}

variable "mig_initial_delay_sec" {
  description = "Initial delay before considering an instance as healthy"
  type        = number
}

variable "http_port_name" {
  description = "Name for the HTTP port"
  type        = string
}

variable "https_port_name" {
  description = "Name for the HTTP port"
  type        = string
}

variable "application_port_name" {
  description = "Name for the application port"
  type        = string
}

variable "max_replicas" {
  description = "Maximum number of replicas for the autoscaler"
  type        = number
}

variable "min_replicas" {
  description = "Minimum number of replicas for the autoscaler"
  type        = number
}

variable "cooldown_period" {
  description = "Cooldown period for the autoscaler"
  type        = number
}

variable "target_cpu_utilization" {
  description = "Target CPU utilization for the autoscaler"
  type        = number
}

##############################################################

#                    VARIABLES - ALB

##############################################################

variable "load_balancing_scheme" {
  description = "The scheme used for the load balancing, EXTERNAL for internet-facing"
  default     = "EXTERNAL"
}

variable "port_range" {
  description = "The range of ports the load balancer listens on, e.g., '443' for HTTPS"
  type        = string
}

variable "backend_mig_timeout_sec" {
  description = "The timeout for the backend service"
  type        = number
}

variable "balancing_mode" {
  description = "The balancing mode for the backend, e.g., UTILIZATION"
  default     = "UTILIZATION"
}

variable "capacity_scaler" {
  description = "The capacity scaler for the backend, 1.0 means 100% capacity"
  type        = number
  default     = 1.0
}
