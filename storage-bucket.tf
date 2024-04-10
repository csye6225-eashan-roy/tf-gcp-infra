resource "google_storage_bucket" "email_verification_function_bucket" {
  name                        = "cloud-function-source-bucket-${random_string.resource_name.result}"
  location                    = var.vpc-region
  force_destroy               = true # Allows the bucket to be destroyed even if it contains objects.
  uniform_bucket_level_access = true
  encryption {
    default_kms_key_name = google_kms_crypto_key.bucket_key.id
  }
  # Ensure the KMS crypto-key IAM binding for the service account exists prior to the
  # bucket attempting to utilise the crypto-key.
  depends_on = [google_kms_crypto_key_iam_binding.gcs_kms_enc_dec]
}

resource "google_storage_bucket_object" "function_source_archive" {
  name   = "src.zip"
  bucket = google_storage_bucket.email_verification_function_bucket.name
  source = "C:\\Users\\HP\\Desktop\\CSYE 6225 Cloud\\GitHub\\serverless\\src.zip"
}