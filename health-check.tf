resource "google_compute_health_check" "webapp_health_check" {
  name = "webapp-health-check-${random_string.resource_name.result}"

  check_interval_sec  = var.check_interval_sec       //how often (in secs) to perform a health check
  timeout_sec         = var.health_check_timeout_sec //how long (in secs) to wait for a response before considering the check failed
  healthy_threshold   = var.healthy_threshold        //number of consecutive successful checks required to mark an unhealthy instance as healthy again
  unhealthy_threshold = var.unhealthy_threshold      //number of consecutive failed checks required to mark a healthy instance as unhealthy

  http_health_check {
    port         = var.port-8081
    request_path = "/healthz"
  }
}