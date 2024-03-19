resource "google_dns_record_set" "a_record" {
  name         = var.dns_name
  type         = var.dns_type
  ttl          = var.dns_ttl
  managed_zone = var.managed_zone
  rrdatas      = [google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip]

  depends_on = [google_compute_instance.vm_instance]
}