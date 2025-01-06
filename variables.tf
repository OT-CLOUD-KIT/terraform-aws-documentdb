variable "cluster_identifier" {
  description = "The cluster identifier"
  type        = string
}

variable "engine_version" {
  description = "The engine version of DocumentDB"
  type        = string
  default     = "5.0.0"
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "master_password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "The instance class to use for the DocumentDB instances"
  type        = string
  default     = "db.t3.medium"
}

variable "number_of_instances" {
  description = "Number of instances to create in the cluster"
  type        = number
  default     = 1
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the cluster will be created"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks that are allowed to access the cluster"
  type        = list(string)
  default     = []
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "03:00-04:00"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final snapshot is created before the cluster is deleted"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "If the cluster should have deletion protection enabled"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_encryption" {
  description = "Specifies whether the DB cluster is encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, enable_encryption needs to be set to true"
  type        = string
  default     = null
}

variable "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch"
  type        = list(string)
  default     = ["audit", "profiler"]
}

variable "enable_performance_insights" {
  description = "Specifies whether Performance Insights is enabled"
  type        = bool
  default     = false
}

variable "snapshot_identifier" {
  description = "Specifies whether to create this cluster from a snapshot"
  type        = string
  default     = null
}

variable "final_snapshot_identifier_prefix" {
  description = "The prefix name for the final snapshot on cluster destroy"
  type        = string
  default     = "final"
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "default"
  }
}

variable "promotion_tier" {
  description = "Failover Priority setting on instance level"
  type        = number
  default     = 0
}

variable "instance_promotion_tiers" {
  description = "Map of instance identifiers to promotion tiers"
  type        = map(number)
  default     = {}
}

variable "cluster_size" {
  description = "Number of instances to create in the cluster"
  type        = number
  default     = 1
}

variable "db_port" {
  description = "Port number on which the DB accepts connections"
  type        = number
  default     = 27017
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "cluster_family" {
  description = "Family of the cluster parameter group"
  type        = string
  default     = "docdb5.0"
}

variable "ssm_parameter_enabled" {
  description = "Whether to store credentials in SSM Parameter Store"
  type        = bool
  default     = false
}

variable "cluster_parameters" {
  description = "List of cluster parameters to apply"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
} 