# Managed SSL Certificate
resource "google_compute_managed_ssl_certificate" "webapp-ssl-certificate" {
  name = "webapp-ssl-certificate-${random_string.resource_name.result}"
  managed {
    domains = ["eashanroy.me"]
  }
}