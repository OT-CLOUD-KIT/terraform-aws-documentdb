output "master_username" {
  description = "DocumentDB Username for the master DB user"
  value       = var.master_username
  sensitive   = true
}

output "cluster_name" {
  description = "DocumentDB Cluster Identifier"
  value       = aws_docdb_cluster.default.cluster_identifier
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the DocumentDB cluster"
  value       = aws_docdb_cluster.default.arn
}

output "security_group_id" {
  description = "ID of the security group associated with the DocumentDB cluster"
  value       = aws_security_group.docdb.id
}

output "endpoint" {
  description = "The DNS address of the DocumentDB instance"
  value       = aws_docdb_cluster.default.endpoint
}

output "reader_endpoint" {
  description = "A read-only endpoint for the DocumentDB cluster"
  value       = aws_docdb_cluster.default.reader_endpoint
} 