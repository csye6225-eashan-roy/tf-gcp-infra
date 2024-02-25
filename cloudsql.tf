// cloudsql database instance
resource "google_sql_database_instance" "cloudsql_instance" {
  name             = "webapp-instance-${random_string.resource_name.result}"
  database_version = var.db-version
  region           = var.vpc-region

  settings {
    tier = var.db-tier
    deletion_protection_enabled = var.db-deletion-protection
    availability_type   = var.db-availability-type
    disk_type           = var.db-disk-type
    disk_size           = var.db-disk-size

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.self_link
    }
  }
}

// cloudsql database
resource "google_sql_database" "webapp_database" {
  name     = "webapp-${random_string.resource_name.result}"
  instance = google_sql_database_instance.cloudsql_instance.name
}

// random password generation
resource "random_password" "db_password" {
  length  = 16
  special = true
}

// cloudsql database user
resource "google_sql_user" "db_user" {
  name     = "webapp-${random_string.resource_name.result}"
  instance = google_sql_database_instance.cloudsql_instance.name
  password = random_password.db_password.result
}

