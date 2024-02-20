resource "google_compute_instance" "vm_instance" {
  name         = "webapp-gcp-vm-packer"
  machine_type = "e2-small"
  zone         = "us-central1-a"

  depends_on = [
    google_compute_network.vpc,
    google_compute_subnetwork.webapp,
    google_compute_route.webapp_internet_access,
    google_compute_firewall.allow_http,
    google_compute_firewall.allow_https,
    google_compute_firewall.allow_ssh
  ]

  boot_disk {
    initialize_params {
      image = "projects/csye6225-eashan-roy/global/images/packer-image-20240220123454"
      size  = 20
    }
  }

  can_ip_forward      = true
  deletion_protection = false


  network_interface {
    subnetwork = google_compute_subnetwork.webapp.self_link
  }

  // Define service account permissions (optional)
  service_account {
    email  = "packer-gcp-custom-images@csye6225-eashan-roy.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["ssh-tag","http-tag","https-tag"]
}