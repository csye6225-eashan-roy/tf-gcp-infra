// VPC 
resource "google_compute_network" "vpc" {
  name                            = "vpc-${random_string.resource_name.result}"
  auto_create_subnetworks         = var.vpc-auto-create-subnets
  routing_mode                    = var.vpc-routing-mode //enables routing to subnets in the same region
  delete_default_routes_on_create = var.vpc-delete-default-routes
}

// Subnet 1 - webapp
resource "google_compute_subnetwork" "webapp" {
  name                     = "webapp-subnet-${random_string.resource_name.result}"
  ip_cidr_range            = var.vpc-webapp-subnet-cidr
  private_ip_google_access = true // Enables VMs in this subnet to access Google APIs and services using their private IP addresses
  region                   = var.vpc-region
  network                  = google_compute_network.vpc.name
}

// Subnet 2 - db
resource "google_compute_subnetwork" "db" {
  name                     = "db-subnet-${random_string.resource_name.result}"
  ip_cidr_range            = var.vpc-db-subnet-cidr
  region                   = var.vpc-region
  private_ip_google_access = true
  network                  = google_compute_network.vpc.name
}

// Reserve IP range for Private Services Access
resource "google_compute_global_address" "private_services_access" {
  name          = "google-managed-services-${random_string.resource_name.result}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

// Connect Google services to VPC
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_services_access.name]
}

// Route for webapp subnet - Internet access
resource "google_compute_route" "webapp_internet_access" {
  name             = "route-${random_string.resource_name.result}"
  dest_range       = var.vpc-webapp-internet-access
  network          = google_compute_network.vpc.name
  next_hop_gateway = var.vpc-next-hop-gateway
}

// Deny all 
resource "google_compute_firewall" "deny_all" {
  name    = "deny-all-${random_string.resource_name.result}"
  network = google_compute_network.vpc.name

  deny {
    protocol = "all"
  }

  priority      = 1000
  source_ranges = var.deny_all_source_ranges
}

// Firewall - allow https
resource "google_compute_firewall" "allow_https_to_vm_from_ALB" {
  name    = "allow-https-to-vm-from-alb-${random_string.resource_name.result}"
  network = google_compute_network.vpc.name

  allow {
    protocol = var.protocol
    ports    = [var.port-https]
  }

  priority      = 999
  source_ranges = var.alb-source-ranges
  target_tags   = [var.firewall-tag-allow-https-to-vm-from-alb]
}

// Firewall - allow http
resource "google_compute_firewall" "allow_http_to_vm_from_ALB" {
  name    = "allow-http-to-vm-from-alb-${random_string.resource_name.result}"
  network = google_compute_network.vpc.name

  allow {
    protocol = var.protocol
    ports    = [var.port-http]
  }

  priority      = 999
  source_ranges = var.alb-source-ranges
  target_tags   = [var.firewall-tag-allow-http-to-vm-from-alb]
}

// Firewall - allow application port
resource "google_compute_firewall" "allow_application_port_to_vm_from_alb" {
  name    = "allow-8081-to-vm-from-alb-${random_string.resource_name.result}"
  network = google_compute_network.vpc.name

  allow {
    protocol = var.protocol
    ports    = [var.port-8081]
  }

  priority      = 999
  source_ranges = var.alb-source-ranges
  target_tags   = [var.firewall-tag-allow-8081-to-vm-from-alb]
}

// Firewall - allow ssh for testing
# resource "google_compute_firewall" "allow_ssh" {
#   name    = "vpc-allow-ssh-${random_string.resource_name.result}"
#   network = google_compute_network.vpc.name

#   allow {
#     protocol = var.protocol
#     ports    = ["22"]
#   }

#   priority      = 999
#   source_ranges = ["0.0.0.0/0"]
# }

// Firewall - deny http
resource "google_compute_firewall" "deny-ingress-http-db" {
  name    = "deny-ingress-http-db-${random_string.resource_name.result}"
  network = google_compute_network.vpc.name
  # direction = "INGRESS"

  deny {
    protocol = var.protocol
    ports    = [var.port-http]
  }

  priority      = 999
  source_ranges = var.deny_all_source_ranges
  source_tags   = [var.firewall-deny-http-tag]
}

// Firewall - deny https
resource "google_compute_firewall" "deny-ingress-https-db" {
  name    = "deny-ingress-https-db-${random_string.resource_name.result}"
  network = google_compute_network.vpc.name
  # direction = "INGRESS"

  deny {
    protocol = var.protocol
    ports    = [var.port-https]
  }

  priority      = 999
  source_ranges = var.deny_all_source_ranges
  source_tags   = [var.firewall-deny-https-tag]
}