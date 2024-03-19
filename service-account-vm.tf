//Service account creation for VM
resource "google_service_account" "vm_service_account" {
  account_id   = "vm-service-account"
  display_name = "VM Service Account"
}

//google project binding for this service account to Role: Logging Admin
resource "google_project_iam_binding" "logging_admin_binding" {
  project = var.project-id
  role    = "roles/logging.admin"

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}",
  ]
}

//google project binding for this service account to Role: Monitoring Metric Writer
resource "google_project_iam_binding" "monitoring_metric_writer_binding" {
  project = var.project-id
  role    = "roles/monitoring.metricWriter"

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}",
  ]
}

//The service account (with 'Logging Admin' and 'Monitoring Metric Writer' roles) is assigned to the VM so that  
//the Ops Agent running on the VM gains the ability to send logs and metrics to Google Cloud's operations suite. 
