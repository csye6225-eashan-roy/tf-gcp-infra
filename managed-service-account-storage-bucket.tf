data "google_storage_project_service_account" "gcs_account" { //fetching Google managed service account
}

resource "google_kms_crypto_key_iam_binding" "gcs_kms_enc_dec" {
  crypto_key_id = google_kms_crypto_key.bucket_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}