output "master_username" {
  value       = aws_docdb_cluster.docdb_cluster.master_username
  description = "Username for the master DB user"
}

output "master_password" {
  value       = aws_docdb_cluster.docdb_cluster.master_password
  description = "Password for the master DB user"
  sensitive   = true
}

output "cluster_name" {
  value       = aws_docdb_cluster.docdb_cluster.cluster_identifier
  description = "Cluster Identifier"
}

output "arn" {
  value       = aws_docdb_cluster.docdb_cluster.arn
  description = "Amazon Resource Name (ARN) of the cluster"
}
