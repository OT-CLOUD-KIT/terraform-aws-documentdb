provider "aws" {
  region = var.region
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
          cidr         = []
          source_SG_ID = []
        }
      ]
    }
  }  
}



module "aws_documentdb_cluster" {
  source                          = "../../"
  cluster_identifier              = var.cluster_identifier
  cluster_size                    = var.cluster_size
  master_username                 = var.master_username
  master_password                 = var.master_password
  instance_class                  = var.instance_class
  db_port                         = var.db_port
  vpc_id                          = var.vpc_id
  subnet_ids                      = var.subnet_ids
  apply_immediately               = var.apply_immediately
  vpc_cidr_block                  = var.vpc_cidr_block
  snapshot_identifier             = var.snapshot_identifier
  retention_period                = var.retention_period
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  vpc_security_group_ids          = [module.documnetdb_security_group.sg_id]
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  cluster_parameters              = var.cluster_parameters
  cluster_family                  = var.cluster_family
  engine                          = var.engine
  engine_version                  = var.engine_version
  storage_encrypted               = var.storage_encrypted
  kms_key_id                      = var.kms_key_id
  skip_final_snapshot             = var.skip_final_snapshot
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  ssm_parameter_enabled           = var.ssm_parameter_enabled
}
