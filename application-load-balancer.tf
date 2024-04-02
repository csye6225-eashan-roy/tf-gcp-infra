# Reserved IP Address for the Load Balancer
resource "google_compute_global_address" "alb-static-ip" {
  name = "webapp-alb-static-ip-${random_string.resource_name.result}"
}

# Global Forwarding Rule for HTTPS
resource "google_compute_global_forwarding_rule" "forwarding-rule" {
  name                  = "webapp-alb-forwarding-rule-${random_string.resource_name.result}"
  ip_protocol           = "TCP"
  load_balancing_scheme = var.load_balancing_scheme
  port_range            = var.port_range //port that the load balancer listens on for incoming traffic
  target                = google_compute_target_https_proxy.https-target-proxy.id
  ip_address            = google_compute_global_address.alb-static-ip.id
}

# Target HTTPS Proxy to check requests against the URL map
resource "google_compute_target_https_proxy" "https-target-proxy" {
  name             = "alb-target-https-proxy-${random_string.resource_name.result}"
  ssl_certificates = [google_compute_managed_ssl_certificate.webapp-ssl-certificate.self_link]
  # SSL termination happens at the target proxy level
  url_map = google_compute_url_map.alb-url-map.id
}

# URL Map to define the backend service and rules
resource "google_compute_url_map" "alb-url-map" {
  name            = "alb-url-map-${random_string.resource_name.result}"
  default_service = google_compute_backend_service.alb-backend-service.id
}

# Backend Service for the URL Map
resource "google_compute_backend_service" "alb-backend-service" {
  name      = "alb-backend-service-${random_string.resource_name.result}"
  protocol  = "HTTP"
  port_name = var.application_port_name # Make sure this matches the name in your MIG named port
  # Port that the backend web application listens on
  load_balancing_scheme = var.load_balancing_scheme
  timeout_sec           = var.backend_mig_timeout_sec
  log_config {
    enable      = true
    sample_rate = 1.0 # Log every request (1.0 = 100%)
  }
  health_checks = [google_compute_health_check.webapp_health_check.id]
  backend {
    group           = google_compute_region_instance_group_manager.webapp-mig.instance_group
    balancing_mode  = var.balancing_mode  //if set to 'UTILIZATION', it means that the load balancer will distribute requests based on the utilization of the instances (e.g., CPU)
    capacity_scaler = var.capacity_scaler //specifies the capacity at which the group works, 1 means 100% capacity
  }
}