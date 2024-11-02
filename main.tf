provider "google" {
  project     = "my-project-279-436907"   # Your GCP project name
  region      = "us-central1"              # Region remains unchanged
  credentials = file("terraform.json")      # Points to your service account key
}

resource "google_compute_instance" "web_server" {
  name         = "web-server-instance"      # Instance name
  machine_type = "f1-micro"                 # Small instance type
  zone         = "us-central1-a"            # Zone for the instance
  tags         = ["http-server"]             # Tags for firewall rules

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"      # Debian 11 as the OS
    }
  }

  network_interface {
    network = "default"                      # Using the default network
    access_config {}                         # Enables ephemeral public IP
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2                # Installs Apache
    systemctl start apache2
    systemctl enable apache2
  EOT
}

output "external_ip" {
  value = google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip  # Outputs the external IP
}
