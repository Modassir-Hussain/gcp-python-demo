provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required APIs
resource "google_project_service" "run" {
  service = "run.googleapis.com"
}

resource "google_project_service" "artifact_registry" {
  service = "artifactregistry.googleapis.com"
}

# Service Account for Cloud Run
resource "google_service_account" "cloudrun_sa" {
  account_id   = "fastapi-cloudrun-sa"
  display_name = "FastAPI Cloud Run Service Account"
}

# Cloud Run Service
resource "google_cloud_run_service" "fastapi" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.cloudrun_sa.email

      containers {
        image = "gcr.io/${var.project_id}/fastapi-demo:latest"

        ports {
          container_port = 8080
        }

        env {
          name  = "ENV"
          value = "prod"
        }
      }
    }
  }

  traffics {
    percent         = 100
    latest_revision = true
  }
}

# Allow public access
resource "google_cloud_run_service_iam_member" "public" {
  service  = google_cloud_run_service.fastapi.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
