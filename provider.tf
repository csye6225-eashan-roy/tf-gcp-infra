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
  project = var.project-id
  region  = var.provider-region
}