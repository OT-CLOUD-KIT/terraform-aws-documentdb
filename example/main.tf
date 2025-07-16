
module "naming" {
  source   = "git@github.com:OT-CLOUD-KIT/terraform-aws-naming.git?ref=dev"
  bu       = var.bu
  env      = var.env
  app      = var.app
  resource = var.resource
}

module "standard_tags" {
  source = "git@github.com:OT-CLOUD-KIT/terraform-aws-standard-tagging.git?ref=dev"

  bu      = var.bu
  program = var.program
  app     = var.app
  team    = var.team
  region  = var.region
  env     = var.env
}


module "documnetdb_security_group" {
  source                             = "OT-CLOUD-KIT/security-groups/aws"
  version                            = "1.0.0"
  enable_whitelist_ip                = false
  enable_source_security_group_entry = true

  name_sg = format("%s-documentdb-security-group", "${var.cluster_identifier}")
  vpc_id  = var.vpc_id
  tags    = var.tags
    ingress_rule = {
    rules = {
      rule_list = [
        {
          description  = "DocumentDB SG"
          from_port    = var.db_port
          to_port      = var.db_port
          protocol     = "tcp"
          cidr         = ["var.vpc_cidr_block"]
          source_SG_ID = [module.documnetdb_security_group.sg_id]
        }
      ]
    }
  }  
}


module "aws_documentdb_cluster" {
  source                          = "../"
  
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
  bu                         = var.bu
  program                    = var.program
  team                       = var.team
  app                        = var.app
  env                        = var.env

  # Network Configuration
  vpc_id                          = var.vpc_id
  subnet_ids                      = var.subnet_ids
  vpc_cidr_block                  = var.vpc_cidr_block
  vpc_security_group_ids          = [module.documnetdb_security_group.sg_id]

  kms_key_id             = var.kms_key_id != null ? var.kms_key_id : null
  storage_encrypted               = var.enable_kms
  # Maintenance and Backup
  apply_immediately               = var.apply_immediately
  snapshot_identifier             = var.snapshot_identifier
  retention_period                = var.retention_period
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  alias_name =  var.alias_name
  deletion_window_in_days = var.deletion_window_in_days
  is_enabled = var.is_enabled
  enable_key_rotation = var.enable_key_rotation
  kms_policy = var.kms_policy
  # Additional Configuration
  cluster_parameters              = var.cluster_parameters
  cluster_family                  = var.cluster_family
  skip_final_snapshot             = var.skip_final_snapshot
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  ssm_parameter_enabled           = var.ssm_parameter_enabled
  deletion_protection             = var.deletion_protection


}

