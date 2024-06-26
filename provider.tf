terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project-id
  region  = var.provider-region
}

provider "google-beta" {
  project = var.project-id
  region  = var.provider-region
}