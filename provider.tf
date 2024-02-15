terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  # credentials = file(var.credentials_file_path)
  // credentials of service account dedicated to Terraform
  project = "csye6225-eashan-roy"
  region  = "us-central1"
}