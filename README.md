# Terraform AWS DocumentDB Cluster Module
[![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png


This Terraform module manages an Amazon DocumentDB (with MongoDB compatibility) cluster on AWS. It provisions the cluster, its instances, associated security groups, subnet groups, and parameter groups.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Usage](#usage)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Examples](#examples)
- [Requirements](#requirements)


## Introduction

Amazon DocumentDB is a fully managed document database service that supports MongoDB workloads. This module provides an easy way to deploy and manage DocumentDB clusters using Terraform.

## Features

- Creates an Amazon DocumentDB cluster with specified configurations.
- Manages cluster instances, subnet groups, and parameter groups.
- Configures security groups to control access to the cluster.
- Supports encryption at rest using AWS KMS.
- Allows customization of backup and maintenance windows.

## Usage

```hcl
provider "aws" {
  region = var.region
}

module "aws_documentdb_cluster" {
  source                          = "../../"
  
  # Basic Configuration
  cluster_identifier              = var.cluster_identifier
  cluster_size                    = var.cluster_size
  instance_class                  = var.instance_class
  db_port                         = var.db_port
  engine                          = var.engine
  engine_version                  = var.engine_version

  # Authentication
  master_username                 = var.master_username
  master_password                 = var.master_password

  # Network Configuration
  vpc_id                          = var.vpc_id
  subnet_ids                      = var.subnet_ids
  vpc_cidr_block                  = var.vpc_cidr_block
  vpc_security_group_ids          = [module.documnetdb_security_group.sg_id]

  # Maintenance and Backup
  apply_immediately               = var.apply_immediately
  snapshot_identifier             = var.snapshot_identifier
  retention_period                = var.retention_period
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window

  # Additional Configuration
  cluster_parameters              = var.cluster_parameters
  cluster_family                  = var.cluster_family
  storage_encrypted               = var.storage_encrypted
  kms_key_id                      = var.kms_key_id
  skip_final_snapshot             = var.skip_final_snapshot
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  ssm_parameter_enabled           = var.ssm_parameter_enabled
  deletion_protection             = var.deletion_protection
  tags                            = var.tags
}
```
## Inputs

### Basic Configuration

| Name                 | Description                                                       | Type     | Default | Required |
|----------------------|-------------------------------------------------------------------|----------|---------|----------|
| region               | The AWS region to deploy the cluster in                           | string   | n/a     | yes      |
| cluster_identifier   | The identifier for the DocumentDB cluster                         | string   | n/a     | yes      |
| master_username      | Username for the master user                                      | string   | n/a     | yes      |
| master_password      | Password for the master user                                      | string   | n/a     | yes      |
| instance_class       | Instance class for the DocumentDB cluster                         | string   | n/a     | yes      |
| db_port              | Port number on which the DB accepts connections                   | number   | 27017   | no       |

### Network Configuration

| Name              | Description                                                       | Type   | Default | Required |
|-------------------|-------------------------------------------------------------------|--------|---------|----------|
| vpc_id            | ID of the VPC where the DB instances will be launched             | string | n/a     | yes      |
| subnet_ids        | List of subnet IDs for the DocumentDB subnet group                | list   | n/a     | yes      |
| vpc_cidr_block    | CIDR block of the VPC                                             | string | n/a     | yes      |

### Maintenance and Backup

| Name                           | Description                                                       | Type   | Default | Required |
|--------------------------------|-------------------------------------------------------------------|--------|---------|----------|
| apply_immediately               | Determines whether changes are applied immediately                | bool   | false   | no       |
| snapshot_identifier             | Snapshot identifier for restoring the DB cluster                   | string | n/a     | no       |
| retention_period                | Number of days to retain backups                                  | number | 7       | no       |
| auto_minor_version_upgrade      | Determines whether minor version upgrades are applied automatically| bool   | true    | no       |
| preferred_backup_window         | Preferred window during which automated backups occur              | string | n/a     | yes      |
| preferred_maintenance_window    | Preferred maintenance window                                      | string | n/a     | yes      |

### Additional Configuration

| Name                           | Description                                                       | Type   | Default | Required |
|--------------------------------|-------------------------------------------------------------------|--------|---------|----------|
| cluster_parameters              | List of cluster parameters to apply                               | list   | n/a     | yes      |
| cluster_family                  | Family of the cluster parameter group                             | string | n/a     | yes      |
| engine                          | Database engine type                                              | string | n/a     | yes      |
| engine_version                  | Version of the database engine                                    | string | n/a     | yes      |
| storage_encrypted               | Whether to enable encryption at rest                              | bool   | true    | no       |
| kms_key_id                      | KMS key ID to use for encryption                                  | string | n/a     | yes      |
| skip_final_snapshot             | Whether to skip the final DB snapshot when deleting the cluster    | bool   | false   | no       |
| enabled_cloudwatch_logs_exports | List of log types to export to CloudWatch Logs                    | list   | n/a     | yes      |
| ssm_parameter_enabled           | Whether to store credentials in SSM Parameter Store               | bool   | false   | no       |
| deletion_protection             | Whether to enable deletion protection for the cluster              | bool   | false   | no       |
| tags                            | Tags to apply to all resources                                    | map    | {}      | no       |


## Related Projects
- [RDS](https://gitlab.com/ot-aws/terrafrom_v0.12.21/rds) - Terraform module for creating Relation Datbase service.
- [DynamoDB](https://github.com/OT-CLOUD-KIT/terraform-aws-dynamodb) - Terraform module for creating DynamoDB.

## Contributors
- [Ankit](https://www.linkedin.com/in/ankit-mishra-aab383210/) 
- [Rajat Vats](https://www.linkedin.com/in/rajat-vats-32042aa9/)