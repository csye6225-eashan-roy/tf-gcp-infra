resource "google_cloudfunctions2_function" "function" {
  name        = "email_verification_function"
  location    = var.vpc-region
  description = "A Cloud Function triggered by Pub/Sub to process email verification."
  # runtime     = "java11"

  build_config {
    runtime     = "java11"
    entry_point = "com.cloud.serverless.EmailVerificationFunction" # Set the entry point
    # environment_variables = {
    #   MAILGUN_API_KEY = "75dcdc418ace512651bc4c2663d4dcb7-f68a26c9-ec0e60c0" # Replace with your Mailgun API key
    # }
    source {
      storage_source {
        bucket = var.bucket_name
        object = var.bucket_object_name
      }
    }
  }

  service_config {
    max_instance_count = 1
    min_instance_count = 1
    available_memory   = var.cloud_function_available_memory
    timeout_seconds    = var.cloud_function_timeout_seconds
    vpc_connector = google_vpc_access_connector.vpc_connector.id
    environment_variables = {
      MAILGUN_API_KEY = "75dcdc418ace512651bc4c2663d4dcb7-f68a26c9-ec0e60c0",
      DB_USER = google_sql_user.db_user.name,
      DB_PASS = random_password.db_password.result,
      DB_NAME = google_sql_database.webapp_database.name,
      DB_HOST = google_sql_database_instance.cloudsql_instance.private_ip_address
    }
    service_account_email = google_service_account.cloud_function_account.email
  }

  event_trigger {
    trigger_region = var.vpc-region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.verify_email_topic.id
    retry_policy   = "RETRY_POLICY_RETRY"
  }
}
