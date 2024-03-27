resource "google_service_account" "cloud_function_account" {
  project      = var.project-id
  account_id   = "cloud-function-service-account"
  display_name = "Cloud Function Service Account"
}

resource "google_project_iam_binding" "cloud_function_pubsub_subscriber" {
  project = var.project-id
  role    = "roles/pubsub.subscriber"

  members = [
    "serviceAccount:${google_service_account.cloud_function_account.email}"
  ]
}

// for Google cloud fucntion to access source code from storage bucket
resource "google_storage_bucket_iam_member" "function_code_viewer" {
  bucket = "serverless-function-source-bucket"
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloud_function_account.email}"
}


resource "google_project_iam_member" "cloudfunction_log_writer" {
  project = var.project-id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloud_function_account.email}"
}

resource "google_project_iam_member" "cloudsql_client" {
  project = var.project-id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_function_account.email}"
}

resource "google_project_iam_member" "service_account_token_creator" {
  project = var.project-id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.cloud_function_account.email}"
}