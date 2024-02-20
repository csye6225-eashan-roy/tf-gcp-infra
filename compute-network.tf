// VPC 
resource "google_compute_network" "vpc" {
  name                            = "vpc-${random_string.resource_name.result}"
  auto_create_subnetworks         = var.vpc-auto-create-subnets
  routing_mode                    = var.vpc-routing-mode //enables routing to subnets in the same region
  delete_default_routes_on_create = var.vpc-delete-default-routes
}

// Subnet 1 - webapp
resource "google_compute_subnetwork" "webapp" {
  name          = "webapp-subnet-${random_string.resource_name.result}"
  ip_cidr_range = var.vpc-webapp-subnet-cidr
  region        = var.vpc-region
  network       = google_compute_network.vpc.name
}

// Subnet 2 - db
resource "google_compute_subnetwork" "db" {
  name          = "db-subnet-${random_string.resource_name.result}"
  ip_cidr_range = var.vpc-db-subnet-cidr
  region        = var.vpc-region
  network       = google_compute_network.vpc.name
}

// Route for webapp subnet - Internet access
resource "google_compute_route" "webapp_internet_access" {
  name             = "route-${random_string.resource_name.result}"
  dest_range       = var.vpc-webapp-internet-access
  network          = google_compute_network.vpc.name
  next_hop_gateway = var.vpc-next-hop-gateway
}

// Firewall - allow https
resource "google_compute_firewall" "allow_https" {
  name    = "vpc-allow-https-${random_string.resource_name.result}"
  network = google_compute_network.vpc.name

  allow {
    protocol = var.protocol
    ports    = [var.port-https]
  }

  source_ranges = var.source_ranges
  target_tags   = [var.firewall-allow-https-tag]
}

// Firewall - allow http
resource "google_compute_firewall" "allow_http" {
  name    = "vpc-allow-http-${random_string.resource_name.result}"
  network = google_compute_network.vpc.name

  allow {
    protocol = var.protocol
    ports    = [var.port-http]
  }

  source_ranges = var.source_ranges
  target_tags   = [var.firewall-allow-http-tag]
}

// Firewall - allow ssh
resource "google_compute_firewall" "allow_ssh" {
  name    = "vpc-allow-ssh-${random_string.resource_name.result}"
  network = google_compute_network.vpc.name

  allow {
    protocol = var.protocol
    ports    = [var.port-ssh]
  }

  source_ranges = var.source_ranges
  target_tags   = [var.firewall-allow-ssh-tag]
}

// Firewall - deny http
resource "google_compute_firewall" "deny-ingress-http-db" {
  name    = "deny-ingress-http-db-${random_string.resource_name.result}"
  network = google_compute_network.vpc.name
  # direction = "INGRESS"

  deny {
    protocol = var.protocol
    ports    = [var.port-http]
  }

  source_ranges = var.source_ranges
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

  source_ranges = var.source_ranges
  source_tags   = [var.firewall-deny-https-tag]
}