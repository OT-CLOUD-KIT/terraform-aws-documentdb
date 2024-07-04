output "master_username" {
  value       = join("", aws_docdb_cluster.default[*].master_username)
  description = "Username for the master DB user"
}

output "master_password" {
  value       = join("", aws_docdb_cluster.default[*].master_password)
  description = "Password for the master DB user"
  sensitive   = true
}

output "cluster_name" {
  value       = join("", aws_docdb_cluster.default[*].cluster_identifier)
  description = "Cluster Identifier"
}

output "arn" {
  value       = join("", aws_docdb_cluster.default[*].arn)
  description = "Amazon Resource Name (ARN) of the cluster"
}


