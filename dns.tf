resource "google_dns_record_set" "a_record" {
  name         = "eashanroy.me."
  type         = "A"
  ttl          = 21600
  managed_zone = "eashanroy"
  rrdatas      = [google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip]

  depends_on = [google_compute_instance.vm_instance]
}