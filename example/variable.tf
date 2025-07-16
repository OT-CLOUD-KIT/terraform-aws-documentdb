variable "region" {
  type        = string
  description = "AWS Region for S3 bucket"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "vpc_cidr_block" {
  type        = list(string)
  description = "VPC CIDR block"
}

variable "allowed_security_groups" {
  type        = list(string)
  default     = []
  description = "List of existing Security Groups to be allowed to connect to the DocumentDB cluster"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks to be allowed to connect to the DocumentDB cluster"
}

variable "instance_class" {
  type        = string
  default     = "db.r4.large"
  description = "The instance class to use. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-instance-classes.html#db-instance-class-specs"
}

variable "cluster_size" {
  type        = number
  default     = 2
  description = "Number of DB instances to create in the cluster"
}

variable "snapshot_identifier" {
  type        = string
  default     = ""
  description = "Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot"
}

variable "db_port" {
  type        = number
  default     = 27017
  description = "DocumentDB port"
}

variable "master_username" {
  type        = string
  default     = "admin1"
  description = "(Required unless a snapshot_identifier is provided) Username for the master DB user"
}

variable "master_password" {
  type        = string
  default     = ""
  description = "(Required unless a snapshot_identifier is provided) Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file. Please refer to the DocumentDB Naming Constraints"
}

variable "retention_period" {
  type        = number
  default     = 5
  description = "Number of days to retain backups for"
}

variable "preferred_backup_window" {
  type        = string
  default     = "07:00-09:00"
  description = "Daily time range during which the backups happen"
}

variable "preferred_maintenance_window" {
  type        = string
  default     = "Mon:22:00-Mon:23:00"
  description = "The window to perform maintenance in. Syntax: `ddd:hh24:mi-ddd:hh24:mi`."
}

variable "cluster_parameters" {
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default     = []
  description = "List of DB parameters to apply"
}

variable "cluster_family" {
  type        = string
  default     = "docdb3.6"
  description = "The family of the DocumentDB cluster parameter group. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-parameter-group-create.html"
}

variable "engine" {
  type        = string
  default     = "docdb"
  description = "The name of the database engine to be used for this DB cluster. Defaults to `docdb`. Valid values: `docdb`"
}

variable "engine_version" {
  type        = string
  default     = "3.6.0"
  description = "The version number of the database engine to use"
}

variable "storage_encrypted" {
  type        = bool
  description = "Specifies whether the DB cluster is encrypted"
  default     = false
}


variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
  default     = true
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  default     = true
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Specifies whether any minor engine upgrades will be applied automatically to the DB instance during the maintenance window or not"
  default     = true
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "List of log types to export to cloudwatch. The following log types are supported: `audit`, `profiler`"
  default     = []
}

variable "cluster_dns_name" {
  type        = string
  description = "Name of the cluster CNAME record to create in the parent DNS zone specified by `zone_id`. If left empty, the name will be auto-asigned using the format `master.var.name`"
  default     = ""
}

variable "reader_dns_name" {
  type        = string
  description = "Name of the reader endpoint CNAME record to create in the parent DNS zone specified by `zone_id`. If left empty, the name will be auto-asigned using the format `replicas.var.name`"
  default     = ""
}

variable "ssm_parameter_enabled" {
  type        = bool
  description = "Whether an SSM parameter store value is created to store the database password."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create the cluster in (e.g. `vpc-a22222ee`)"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of VPC subnet IDs to place DocumentDB instances in"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {
    Environment = "devops"
  }
}

variable "cluster_identifier" {
  description = "The DocumentDB cluster identifier"
  type        = string
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Flag to control the documentDB creation."
}

variable "deletion_protection" {
  type        = bool
  description = "A value that indicates whether the DB cluster has deletion protection enabled"
  default     = false
}


variable "env" {
  type        = string
  description = "Environment (d, p, q, s, g)"
  default     = "p"
  validation {
    condition     = contains(["d", "p", "q", "s", "g"], var.env)
    error_message = "env must be one of: d, p, q, s, g"
  }
}

variable "bu" {
  type        = string
  description = "Business unit (max 10 characters)"
  default     = "BP"
  validation {
    condition     = length(var.bu) <= 10
    error_message = "Business unit name must be <= 10 characters"
  }
}

variable "app" {
  type        = string
  description = "Application name (max 10 characters)"
  default     = "database"
  validation {
    condition     = length(var.app) <= 10
    error_message = "App name must be <= 10 characters"
  }
}

variable "program" {
  type        = string
  description = "Program name (e.g., ot-cloud-kit)"
  default     = "OT"
}

variable "resource" {
  type        = string
  description = "Optional resource name (max 15 characters)"
  default     = ""
  validation {
    condition     = length(var.resource) <= 20
    error_message = "Resource name must be <= 15 characters"
  }
}

variable "team" {
  type        = string
  description = "Team owner or contact (e.g., devops@example.com)"
  default     = "infra"
}


variable "create" {
  type        = bool
  description = "Whether to create resources (module-level toggle)"
  default     = true
}

variable "random_alphanumeric_len" {
  type        = number
  description = "Length of random alphanumeric string to append (1 to 4)"
  default     = 2
  validation {
    condition     = var.random_alphanumeric_len >= 1 && var.random_alphanumeric_len <= 4
    error_message = "Length must be between 1 and 4"
  }
}

variable "special" {
  type        = bool
  description = "Include special characters in generated names"
  default     = false
}

variable "upper" {
  type        = bool
  description = "Include uppercase characters in generated names"
  default     = false
}

variable "number" {
  type        = bool
  description = "Include numbers in generated names"
  default     = true
}

variable "gen_no_of_names" {
  type        = number
  description = "How many names to generate using random naming logic"
  default     = 1
}

variable "enable_kms" {
  type = bool
  default = false

}

variable "kms_key_id" {
  type =  string
  default = ""
}


variable "alias_name" {
  description = "the name of the key alias"
  type = string
}

variable "deletion_window_in_days" {
  description = "The duration in days after which the key is deleted after destruction of the resource"
  type = string
  default = 30
}

variable "is_enabled" {
  description = "Status of key enable or disbale"
  type        = bool
  default     = true
}

variable "enable_key_rotation" {
  description = "enable_key_rotation"
  type        = bool
  default     = true
}

variable "kms_policy" {
   description = "The policy of the key usage"
  type        = string
  default     = ""
}