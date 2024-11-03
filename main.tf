provider "google" {
  project = "my-project-279-436907" // Replace with your GCP project ID
  region  = "us-central1"
  zone    = "us-central1-f"
}

resource "google_compute_network" "custom_vpc" {
  name                    = "test-custom-jenkins-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "custom_subnet" {
  name          = "test-cmd-subnets"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.custom_vpc.id
}

resource "google_compute_instance" "vm_instance" {
  name         = "instance-jenkins-vpc-subnet"
  machine_type = "e2-medium"
  zone         = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11" // Replace with desired image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.custom_subnet.id
    access_config {
      // This block enables an ephemeral public IP
    }
  }

  service_account {
    email  = "jenkins@my-project-279-436907.iam.gserviceaccount.com" // Replace with your service account email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
