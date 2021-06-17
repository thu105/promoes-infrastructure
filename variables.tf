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

variable "network_name" {
  description = "The VPC network created to host the cluster in"
  default     = "vpc-network"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  default     = "ip-range-svc"
}

variable "peering_address_name" {
  description = "The VPC network address name for peering"
  default     = "vpc-peering-address"
}
