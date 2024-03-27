resource "google_compute_instance" "vm_instance" {
  name         = var.vm-name
  machine_type = var.vm-size
  zone         = var.vm-zone

  depends_on = [
    google_service_account.vm_service_account,
    google_project_iam_binding.logging_admin_binding,
    google_project_iam_binding.monitoring_metric_writer_binding,
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

  // Define service account for VM
  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = [var.service-account-scope]
  }

  metadata = {
    db_host     = google_sql_database_instance.cloudsql_instance.private_ip_address
    db_name     = google_sql_database.webapp_database.name
    db_user     = google_sql_user.db_user.name
    db_password = random_password.db_password.result
  }

  metadata_startup_script = file("vm-startup-script.sh") // Path to startup script file

  tags = var.vm-tags
}