# Delcare required providers
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.72.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.3.2"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

# Create vpc-network and setup network peering
resource "google_compute_network" "vpc_network" {
  provider = google
  name = var.network_name
}
  
resource "google_compute_global_address" "vpc_peering_address" {
  provider = google

  name          = var.peering_address_name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}
  
resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google

  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.vpc_peering_address.name]
}

# Create GKE Cluster
module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = var.cluster_name
  regional                   = false
  region                     = var.region
  network                    = google_compute_network.vpc_network.id
  subnetwork                 = google_compute_network.vpc_network.id
  ip_range_pods              = var.ip_range_pods_name
  ip_range_services          = var.ip_range_services_name
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = false
  create_service_account     = true
  zones                      = [var.zone]

  node_pools = [
    {
      name                      = "default-node-pool"
      machine_type              = "e2-medium"
      min_count                 = 0
      max_count                 = 3
      local_ssd_count           = 0
      disk_size_gb              = 100
      disk_type                 = "pd-standard"
      image_type                = "cos_containerd"
      auto_repair               = true
      auto_upgrade              = true
      preemptible               = false
      initial_node_count        = 0
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

# Create private POSTGRES SQL instance for Kong
resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "kong_sql" {
  provider = google

  name   = "kong-sql-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_13"
  region = var.region

  depends_on = [google_service_networking_connection.private_vpc_connection]
  deletion_protection = false
  
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.id
    }
    availability_type = "ZONAL"
    
  }
}
  
resource "google_sql_database" "kong_db" {
  name     = "kong"
  instance = google_sql_database_instance.kong_sql.name
}
  
resource "google_sql_user" "users" {
  name     = "kong"
  instance = google_sql_database_instance.kong_sql.name
  password = "kong"
}
