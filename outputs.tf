output "kubernetes_endpoint" {
  description = "The cluster endpoint"
  sensitive   = true
  value       = module.gke.endpoint
}

output "client_token" {
  description = "The bearer token for auth"
  sensitive   = true
  value       = base64encode(data.google_client_config.default.access_token)
}

output "ca_certificate" {
  description = "The cluster ca certificate (base64 encoded)"
  sensitive   = true
  value       = module.gke.ca_certificate
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.gke.service_account
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "network_name" {
  description = "The name of the VPC being created"
  value       = google_compute_network.vpc_network.name
}
  
output "sql_instance_name" {
  description = "The name of the Postgres SQL Server being created"
  value       = google_sql_database_instance.kong_sql.name 
}
