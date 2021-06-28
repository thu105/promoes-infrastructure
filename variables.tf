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

variable "subnetwork_name" {
  description = "The subnetwork created to host the cluster in"
  default     = "vpc-subnet"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  default     = "ip-range-svc"
}

variable "kong_db_secret_id" {
  description = "Secret used for authentication with Kong DB"
  default     = "kong-ps-password"
}
