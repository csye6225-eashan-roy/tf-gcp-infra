resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  provider = google-beta
  service  = "sqladmin.googleapis.com"
}

resource "google_kms_crypto_key_iam_binding" "sql_kms_enc_dec" {
  provider      = google-beta
  crypto_key_id = google_kms_crypto_key.sql_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = ["serviceAccount:service-547281903181@gcp-sa-cloud-sql.iam.gserviceaccount.com"] //Google managed service account

}