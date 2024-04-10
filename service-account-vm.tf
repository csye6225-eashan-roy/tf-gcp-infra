//Service account creation for VM
resource "google_service_account" "vm_service_account" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
}

//google project binding for this service account to Role: Logging Admin
resource "google_project_iam_binding" "logging_admin_binding" {
  project = var.project-id
  role    = var.logging_admin_role

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}",
  ]
}

//google project binding for this service account to Role: Monitoring Metric Writer
resource "google_project_iam_binding" "monitoring_metric_writer_binding" {
  project = var.project-id
  role    = var.monitoring_metric_writer_role

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}",
  ]
}

//The service account (with 'Logging Admin' and 'Monitoring Metric Writer' roles) is assigned to the VM so that  
//the Ops Agent running on the VM gains the ability to send logs and metrics to Google Cloud's operations suite. 

//google project binding for this service account to Role: Pub/Sub Publisher
resource "google_project_iam_binding" "vm_pubsub_publisher" {
  project = var.project-id
  role    = "roles/pubsub.publisher"

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}",
  ]
}

resource "google_kms_crypto_key_iam_binding" "vm_kms_enc_dec" {
  provider      = google-beta
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  crypto_key_id = google_kms_crypto_key.vm_key.id
  members = ["serviceAccount:service-547281903181@compute-system.iam.gserviceaccount.com",
  "serviceAccount:${google_service_account.vm_service_account.email}"]
}
