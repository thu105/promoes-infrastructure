terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.72.0"
    }
  }
}

provider "google" {
  project = "{{YOUR GCP PROJECT}}"
  region  = "us-central1"
  zone    = "us-central1-c"
}

module "kubernetes-engine" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "15.0.0"
  # insert the 9 required variables here
}
