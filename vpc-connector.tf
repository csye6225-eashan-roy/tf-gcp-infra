resource "google_vpc_access_connector" "vpc_connector" {
  name          = "cf-to-sql-vc-${substr(random_string.resource_name.result, 0, 15)}"
  region        = var.vpc-region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.vpc_access_connector_ip_cidr_range
}
