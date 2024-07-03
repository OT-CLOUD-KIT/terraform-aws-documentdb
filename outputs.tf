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


output "security_group_id" {
  description = "ID of the DocumentDB cluster Security Group"
  value       = join("", aws_security_group.default[*].id)
}

output "security_group_arn" {
  description = "ARN of the DocumentDB cluster Security Group"
  value       = join("", aws_security_group.default[*].arn)
}

output "security_group_name" {
  description = "Name of the DocumentDB cluster Security Group"
  value       = join("", aws_security_group.default[*].name)
}