# Terraform AWS DocumentDB Cluster Module

This Terraform module manages an Amazon DocumentDB (with MongoDB compatibility) cluster on AWS. It provisions the cluster, its instances, associated security groups, subnet groups, and parameter groups.




## Features

- Creates an Amazon DocumentDB cluster with specified configurations.
- Manages cluster instances, subnet groups, and parameter groups.
- Configures security groups to control access to the cluster.
- Supports encryption at rest using AWS KMS.
- Allows customization of backup and maintenance windows.




## Providers

| Name                                              | Version  |
|---------------------------------------------------|----------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2   |
| <a name="terraform_module"></a> [Terraform](Terraform\module) | >= 1.12.1|

___

## Architecture

<img width="1196" height="666" alt="Screenshot from 2025-07-16 19-11-15" src="https://github.com/user-attachments/assets/d643e461-8ad0-460d-8003-c28335819b77" />


___


## Usage

```hcl
module "aws_documentdb_cluster" {
  source = "OT-CLOUD-KIT/terraform-aws-documentdb"

  # Basic Configuration
  cluster_identifier   = "proddocdb"
  cluster_size         = 1
  instance_class       = "db.t3.medium"
  db_port              = 27017
  engine               = "docdb"
  engine_version       = "5.0.0"

  # Authentication
  master_username = "documentdb"
  master_password = "abcd1234"
  bu              = "BP"
  program         = "OT"
  team            = "devops"
  app             = "db"
  env             = "d"

  # Network Configuration
  vpc_id                 = "vpc-03ddd7fd3163cc23a"
  subnet_ids             = ["subnet-0759f0a3ac70e88c7", "subnet-0d5d2a5274faf7485"]
  vpc_cidr_block         = ["10.0.0.0/16"]
  vpc_security_group_ids = [module.documnetdb_security_group.sg_id]

  kms_key_id        = null
  storage_encrypted = false

  # Maintenance and Backup
  apply_immediately            = true
  snapshot_identifier          = null
  retention_period             = 5
  auto_minor_version_upgrade   = true
  preferred_backup_window      = "07:00-09:00"
  preferred_maintenance_window = null

  alias_name              = "proddocdb-kms-key"
  deletion_window_in_days = 10
  is_enabled              = true
  enable_key_rotation     = true

  kms_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF

  # Additional Configuration
  cluster_parameters              = var.cluster_parameters
  cluster_family                  = "docdb5.0"
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  ssm_parameter_enabled           = true
  deletion_protection             = false
}

```


> **Note:**  
> The above example demonstrates how to use the module. All variables, resources, and outputs used here are already defined within this module.






## Resources


| Name                                                                                                                                                                       | Type     |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws\_docdb\_cluster.docdb\_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster)                                            | resource |
| [aws\_docdb\_cluster\_instance.docdb\_cluster\_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_instance)               | resource |
| [aws\_docdb\_subnet\_group.docdb\_subnet\_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_subnet_group)                           | resource |
| [aws\_docdb\_cluster\_parameter\_group.docdb\_parameter\_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_parameter_group) | resource |
| [aws\_kms\_key.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)                                                                   | resource |
| [aws\_kms\_alias.key\_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias)                                                        | resource |

___
## Input

| Name                                                                                                                              | Description                                                         | Type           | Default | Required |
| --------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_region"></a> [region](#input_region)                                                                               | The AWS region to deploy the cluster in                             | `string`       | n/a     |    yes   |
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input_cluster_identifier)                                          | The identifier for the DocumentDB cluster                           | `string`       | n/a     |    yes   |
| <a name="input_master_username"></a> [master\_username](#input_master_username)                                                   | Username for the master user                                        | `string`       | n/a     |    yes   |
| <a name="input_master_password"></a> [master\_password](#input_master_password)                                                   | Password for the master user                                        | `string`       | n/a     |    yes   |
| <a name="input_instance_class"></a> [instance\_class](#input_instance_class)                                                      | Instance class for the DocumentDB cluster                           | `string`       | n/a     |    yes   |
| <a name="input_db_port"></a> [db\_port](#input_db_port)                                                                           | Port number on which the DB accepts connections                     | `number`       | `27017` |    no    |
| <a name="input_vpc_id"></a> [vpc\_id](#input_vpc_id)                                                                              | ID of the VPC where the DB instances will be launched               | `string`       | n/a     |    yes   |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input_subnet_ids)                                                                  | List of subnet IDs for the DocumentDB subnet group                  | `list(string)` | n/a     |    yes   |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input_vpc_cidr_block)                                                     | CIDR block of the VPC                                               | `string`       | n/a     |    yes   |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input_apply_immediately)                                             | Determines whether changes are applied immediately                  | `bool`         | `false` |    no    |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input_snapshot_identifier)                                       | Snapshot identifier for restoring the DB cluster                    | `string`       | n/a     |    no    |
| <a name="input_retention_period"></a> [retention\_period](#input_retention_period)                                                | Number of days to retain backups                                    | `number`       | `7`     |    no    |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input_auto_minor_version_upgrade)                | Determines whether minor version upgrades are applied automatically | `bool`         | `true`  |    no    |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input_preferred_backup_window)                          | Preferred window during which automated backups occur               | `string`       | n/a     |    yes   |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input_preferred_maintenance_window)           | Preferred maintenance window                                        | `string`       | n/a     |    yes   |
| <a name="input_cluster_parameters"></a> [cluster\_parameters](#input_cluster_parameters)                                          | List of cluster parameters to apply                                 | `list(object)` | n/a     |    yes   |
| <a name="input_cluster_family"></a> [cluster\_family](#input_cluster_family)                                                      | Family of the cluster parameter group                               | `string`       | n/a     |    yes   |
| <a name="input_engine"></a> [engine](#input_engine)                                                                               | Database engine type                                                | `string`       | n/a     |    yes   |
| <a name="input_engine_version"></a> [engine\_version](#input_engine_version)                                                      | Version of the database engine                                      | `string`       | n/a     |    yes   |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input_storage_encrypted)                                             | Whether to enable encryption at rest                                | `bool`         | `true`  |    no    |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input_kms_key_id)                                                                 | KMS key ID to use for encryption                                    | `string`       | n/a     |    yes   |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input_skip_final_snapshot)                                      | Whether to skip the final DB snapshot when deleting the cluster     | `bool`         | `false` |    no    |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input_enabled_cloudwatch_logs_exports) | List of log types to export to CloudWatch Logs                      | `list(string)` | n/a     |    yes   |
| <a name="input_ssm_parameter_enabled"></a> [ssm\_parameter\_enabled](#input_ssm_parameter_enabled)                                | Whether to store credentials in SSM Parameter Store                 | `bool`         | `false` |    no    |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input_deletion_protection)                                       | Whether to enable deletion protection for the cluster               | `bool`         | `false` |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                     | Tags to apply to all resources                                      | `map(string)`  | `{}`    |    no    |

___

## Output

| Name                                                                                     | Description                                                      |
| ---------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| <a name="output_master_username"></a> [master\_username](#output_master_username)        | DocumentDB Username for the master DB user.                      |
| <a name="output_cluster_name"></a> [cluster\_name](#output_cluster_name)                 | DocumentDB Cluster Identifier.                                   |
| <a name="output_arn"></a> [arn](#output_arn)                                             | Amazon Resource Name (ARN) of the DocumentDB cluster.            |
| <a name="output_security_group_id"></a> [security\_group\_id](#output_security_group_id) | ID of the security group associated with the DocumentDB cluster. |

___
## Contributors

- [Piyush Upadhyay](https://github.com/piiiyuushh)
- [Nikita Joshi](https://github.com/jnikita19)



