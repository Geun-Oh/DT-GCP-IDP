provider "google" {
  credentials = var.credential_file
  project     = var.project_name
  region      = var.region
}

resource "google_storage_bucket_object" "object" {
  name   = "src"
  bucket = var.bucket_name
  source = "src.zip"
}

resource "google_cloudfunctions2_function" "function" {
  name        = var.function_name
  location    = var.region
  description = "gcp deploy"

  build_config {
    runtime     = "nodejs20"
    entry_point = var.entry_point
    source {
      storage_source {
        bucket = var.bucket_name
        object = google_storage_bucket_object.object.name
      }
    }
  }
  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
  }
}
resource "google_cloudfunctions_function_iam_binding" "my_function_iam_binding" {
  project        = var.project_name
  region         = var.region
  cloud_function = google_cloudfunctions2_function.function.name

  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers"
  ]
}
output "function_uri" {
  value = google_cloudfunctions2_function.function.service_config[0].uri
}
