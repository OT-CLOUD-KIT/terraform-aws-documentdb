output "master_username" {
  value       = module.aws_documentdb_cluster.master_username
  description = "DocumentDB Username for the master DB user"
}

output "cluster_name" {
  value       = module.aws_documentdb_cluster.cluster_name
  description = "DocumentDB Cluster Identifier"
}

output "arn" {
  value       = module.aws_documentdb_cluster.arn
  description = "Amazon Resource Name (ARN) of the DocumentDB cluster"
}

output "security_group_id" {
  value = module.documnetdb_security_group.sg_id
}
