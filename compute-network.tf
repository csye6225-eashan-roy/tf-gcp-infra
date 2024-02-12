// VPC 
resource "google_compute_network" "vpc" {
  name                    = "vpc-${random_string.resource_name.result}"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL" //enables routing to subnets in the same region
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
  name       = "route-${random_string.resource_name.result}"
  dest_range = var.webapp-internet-access
  network    = google_compute_network.vpc.name
  next_hop_gateway = "default-internet-gateway"
}