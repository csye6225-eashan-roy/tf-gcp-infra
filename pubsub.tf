resource "google_pubsub_topic" "verify_email_topic" {
  name                       = var.pubsub_topic_name
  message_retention_duration = var.message_retention_duration
  message_storage_policy {
    allowed_persistence_regions = [var.message_storage_region]
  }
}

resource "google_pubsub_subscription" "verify_email_subscription" {
  name                 = var.pubsub_subscription_name
  topic                = google_pubsub_topic.verify_email_topic.name
  ack_deadline_seconds = var.ack_deadline_seconds
}