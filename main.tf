provider "google" {
  project     = "my-project-279-436907"
  region      = "us-central1"
}

resource "google_compute_network" "custom-test" {
  name                    = "test-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.custom-test.name
}

resource "google_compute_instance" "default" {
  name         = "instance-vpc-automation"
  machine_type = "e2-medium"
  zone         = "us-central1-c"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.custom-test.name
    subnetwork = google_compute_subnetwork.network-with-private-secondary-ip-ranges.name

    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    email  = "jenkins@my-project-279-436907.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
