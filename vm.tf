resource "google_compute_instance" "vm_instance" {
  name         = var.vm-name
  machine_type = var.vm-size
  zone         = var.vm-zone

  depends_on = [
    google_compute_network.vpc,
    google_compute_subnetwork.webapp,
    google_compute_route.webapp_internet_access,
    google_compute_firewall.allow_http,
    google_compute_firewall.allow_https,
    google_compute_firewall.allow_application_port
  ]

  boot_disk {
    initialize_params {
      image = var.packer-image-path
      size  = var.vm-storage
      type  = var.vm-type
    }
  }

  can_ip_forward      = var.vm-can-ip-forward
  deletion_protection = var.vm-deletion-protection


  network_interface {
    subnetwork = google_compute_subnetwork.webapp.self_link
    access_config {
      // This block assigns an external IP
    }

  }

  // Define service account permissions (optional)
  service_account {
    email  = var.service-account-email
    scopes = [var.service-account-scope]
  }

  tags = var.vm-tags
}