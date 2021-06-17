variable "project_id" {
  description = "The project ID to host the cluster in"
  default     = "promoes"
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "gke-cluster-1"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "zone" {
  description = "The region project is in"
  default     = "us-central1-c"
}

variable "network" {
  description = "The VPC network created to host the cluster in"
  default     = "vpc-network"
}
