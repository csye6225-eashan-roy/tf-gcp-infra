// VPC 
resource "google_compute_network" "vpc" {
  name                            = "vpc-${random_string.resource_name.result}"
  auto_create_subnetworks         = false
  routing_mode                    = var.routing-mode //enables routing to subnets in the same region
  delete_default_routes_on_create = true
}

// Subnet 1 - webapp
resource "google_compute_subnetwork" "webapp" {
  name          = "webapp-subnet-${random_string.resource_name.result}"
  ip_cidr_range = var.webapp-subnet-cidr
  region        = var.region
  network       = google_compute_network.vpc.name
}

// Subnet 2 - db
resource "google_compute_subnetwork" "db" {
  name          = "db-subnet-${random_string.resource_name.result}"
  ip_cidr_range = var.db-subnet-cidr
  region        = var.region
  network       = google_compute_network.vpc.name
}

// Route for webapp subnet - Internet access
resource "google_compute_route" "webapp_internet_access" {
  name             = "route-${random_string.resource_name.result}"
  dest_range       = var.webapp-internet-access
  network          = google_compute_network.vpc.name
  next_hop_gateway = "default-internet-gateway"
}

resource "google_compute_firewall" "allow_https" {
  name    = "vpc-allow-https"
  network = google_compute_network.vpc.name

  allow {
    protocol = var.protocol
    ports    = [var.port-https]
  }

  source_ranges = var.source_ranges
  target_tags   = ["https-tag"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "vpc-allow-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = var.protocol
    ports    = [var.port-http]
  }

  source_ranges = var.source_ranges
  target_tags   = ["http-tag"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "vpc-allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = var.protocol
    ports    = [var.port-ssh]
  }

  source_ranges = var.source_ranges
  target_tags   = ["ssh-tag"]
}

# resource "google_compute_firewall" "http-https-ssh-ingress-webapp" {
#   name      = "http-https-ssh-ingress-webapp"
#   network   = google_compute_network.vpc.name
#   direction = "INGRESS" // This is the default value and can be omitted

#   allow {
#     protocol = var.protocol
#     ports    = var.ports
#   }

#   source_ranges = var.source_ranges
#   target_tags   = ["webapp"]
# }

resource "google_compute_firewall" "deny-ingress-http-db" {
  name      = "deny-ingress-http-db"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"

  deny {
    protocol = var.protocol
    ports    = [var.port-http]
  }

  source_ranges = var.source_ranges
  source_tags   = ["db"]
}

resource "google_compute_firewall" "deny-ingress-https-db" {
  name      = "deny-ingress-https-db"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"

  deny {
    protocol = var.protocol
    ports    = [var.port-https]
  }

  source_ranges = var.source_ranges
  source_tags   = ["db"]
}