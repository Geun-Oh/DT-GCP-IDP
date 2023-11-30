provider "google" {
  credentials = jsondecode(var.credential_file)
  project     = var.project_name
  region      = var.region
}

resource "google_storage_bucket_object" "object" {
  name   = "src"
  bucket = var.bucket_name
  source = "src.zip"
}

resource "google_cloudfunctions2_function" "function" {
  name        = "new-function"
  location    = var.region
  description = "gcp deploy"

  build_config {
    runtime     = "nodejs20"
    entry_point = "helloHttp"
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

output "function_uri" {
  value = google_cloudfunctions2_function.function.service_config[0].uri
}
