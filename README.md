This Terraform module manages an Amazon DocumentDB (with MongoDB compatibility) cluster on AWS. It provisions the cluster, its instances, associated security groups, subnet groups, and parameter groups with enhanced security features and best practices.

## Table of Contents

* [Introduction](#introduction)
* [Features](#features)
* [Usage](#usage)
* [Use Cases](#use-cases)
* [Inputs](#inputs)
* [Outputs](#outputs)
* [Related Projects](#related-projects)
* [Contributors](#contributors)

## Introduction

Amazon DocumentDB is a fully managed document database service that supports MongoDB workloads. This module provides a secure and flexible way to deploy and manage DocumentDB clusters using Terraform, with built-in security best practices and comprehensive monitoring capabilities.

## Features

* Creates a fully managed DocumentDB cluster with specified configurations
* Enhanced security features:
  * Enforced TLS encryption
  * Automatic audit logging
  * Profiler enabled by default
  * Comprehensive security group rules
  * Default deletion protection
* Advanced instance management with promotion tiers for failover priorities
* Flexible parameter group management with secure defaults
* SSM Parameter Store integration for credential management
* CloudWatch logs integration with performance insights
* Customizable backup and maintenance windows
* Support for encryption at rest using AWS KMS
* Comprehensive tagging strategy

## Usage
hcl
provider "aws" {
region = "us-west-2"
}
module "documentdb" {
source = "path/to/module"
# Basic Configuration
cluster_identifier = "my-docdb-cluster"
engine_version = "5.0.0"
# Network Configuration
vpc_id = "vpc-xxxxxx"
subnet_ids = ["subnet-xxxxx", "subnet-yyyyy"]
vpc_cidr_block = "10.0.0.0/16"
allowed_cidr_blocks = ["10.0.0.0/16"]
# Instance Configuration
instance_class = "db.r5.large"
number_of_instances = 3
# Authentication
master_username = "dbadmin"
master_password = "your-secure-password"
# Backup Configuration
backup_retention_period = 14
preferred_backup_window = "03:00-04:00"
# Maintenance
preferred_maintenance_window = "sun:05:00-sun:06:00"
# Security
enable_encryption = true
deletion_protection = true
# Monitoring
enable_cloudwatch_logs_exports = ["audit", "profiler"]
enable_performance_insights = true
# SSM Integration
ssm_parameter_enabled = true
tags = {
Environment = "production"
Project = "my-project"
}
}

## Use Cases

### 1. Development Environment Setup

Basic setup with minimal resources and relaxed security for development purposes:

hcl
module "dev_documentdb" {
source = "path/to/module"
cluster_identifier = "dev-docdb"
instance_class = "db.t3.medium"
number_of_instances = 1
deletion_protection = false
skip_final_snapshot = true
tags = {
Environment = "development"
}
}


### 2. Production Environment with High Availability

Secure setup with multiple instances and enhanced monitoring:

hcl
module "prod_documentdb" {
source = "path/to/module"
cluster_identifier = "prod-docdb"
instance_class = "db.r5.large"
number_of_instances = 3
instance_promotion_tiers = {
1 = 0 # Primary
2 = 1 # First Secondary
3 = 2 # Second Secondary
}
enable_cloudwatch_logs_exports = ["audit", "profiler"]
enable_performance_insights = true
ssm_parameter_enabled = true
tags = {
Environment = "production"
}
}

## Inputs

### Basic Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_identifier | The cluster identifier | string | n/a | yes |
| engine_version | The engine version of DocumentDB | string | "5.0.0" | no |
| master_username | Username for the master DB user | string | n/a | yes |
| master_password | Password for the master DB user | string | n/a | yes |
| instance_class | The instance class for DB instances | string | "db.t3.medium" | no |
| number_of_instances | Number of DB instances | number | 1 | no |

### Network Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | VPC ID where the cluster will be created | string | n/a | yes |
| subnet_ids | List of subnet IDs for the cluster | list(string) | n/a | yes |
| vpc_cidr_block | CIDR block of the VPC | string | n/a | yes |
| allowed_cidr_blocks | CIDR blocks allowed to access the cluster | list(string) | [] | no |

### Security Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_encryption | Enable encryption at rest | bool | true | no |
| kms_key_id | KMS key ID for encryption | string | null | no |
| deletion_protection | Enable deletion protection | bool | true | no |
| ssm_parameter_enabled | Store credentials in SSM Parameter Store | bool | false | no |

### Backup and Maintenance

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backup_retention_period | Days to retain backups | number | 7 | no |
| preferred_backup_window | Daily backup window | string | "03:00-04:00" | no |
| preferred_maintenance_window | Weekly maintenance window | string | "sun:05:00-sun:06:00" | no |
| skip_final_snapshot | Skip final snapshot on deletion | bool | false | no |

### Monitoring and Performance

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_cloudwatch_logs_exports | Log types to export to CloudWatch | list(string) | ["audit", "profiler"] | no |
| enable_performance_insights | Enable Performance Insights | bool | false | no |
| cluster_parameters | List of cluster parameters to apply | list(object) | [] | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_endpoint | The cluster endpoint |
| cluster_reader_endpoint | The cluster reader endpoint |
| cluster_instances | List of cluster instance IDs |
| cluster_resource_id | The Resource ID of the cluster |
| cluster_arn | The ARN of the cluster |
| security_group_id | The security group ID |

## Related Projects

* [terraform-aws-rds](https://github.com/OT-CLOUD-KIT/terraform-aws-rds) - Terraform module for RDS
* [terraform-aws-eks](https://github.com/OT-CLOUD-KIT/terraform-aws-eks) - Terraform module for EKS
* [terraform-aws-vpc](https://github.com/OT-CLOUD-KIT/terraform-aws-vpc) - Terraform module for VPC

## Contributors

|  [![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>[Opstree Solutions][opstree_homepage] |
| :---: |

[opstree_homepage]: https://github.com/OT-CLOUD-KIT
[opstree_avatar]: https://img.shields.io/badge/Opstree%20Solutions-Terraform%20Modules-blue