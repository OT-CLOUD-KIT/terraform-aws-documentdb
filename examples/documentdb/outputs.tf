# output "vpc_cidr" {
#   value       = module.vpc.vpc_cidr_block
#   description = "VPC ID"
# }

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
  value       = module.aws_documentdb_cluster.security_group_id
  description = "ID of the DocumentDB cluster Security Group"
}

output "security_group_arn" {
  value       = module.aws_documentdb_cluster.security_group_arn
  description = "ARN of the DocumentDB cluster Security Group"
}

output "security_group_name" {
  value       = module.aws_documentdb_cluster.security_group_name
  description = "Name of the DocumentDB cluster Security Group"
}
