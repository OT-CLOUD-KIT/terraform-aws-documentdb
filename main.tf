resource "aws_docdb_cluster" "default" {
  count                           = var.enabled? 1 : 0
  cluster_identifier              = var.cluster_identifier
  master_username                 = var.master_username
  master_password                 = var.master_password 
  backup_retention_period         = var.retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  final_snapshot_identifier       = lower(var.cluster_identifier)
  skip_final_snapshot             = var.skip_final_snapshot
  deletion_protection             = var.deletion_protection
  apply_immediately               = var.apply_immediately
  storage_encrypted               = var.storage_encrypted
  storage_type                    = var.storage_type
  vpc_security_group_ids          = var.vpc_security_group_ids
  kms_key_id                      = var.kms_key_id
  port                            = var.db_port
  snapshot_identifier             = var.snapshot_identifier
  db_subnet_group_name            = join("", aws_docdb_subnet_group.default[*].name)
  db_cluster_parameter_group_name = join("", aws_docdb_cluster_parameter_group.default[*].name)
  engine                          = var.engine
  engine_version                  = var.engine_version
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  allow_major_version_upgrade     = var.allow_major_version_upgrade
  tags                            = var.tags
}

resource "aws_docdb_cluster_instance" "default" {
  count                        = "1"
  identifier                   = "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier           = join("", aws_docdb_cluster.default[*].id)
  apply_immediately            = var.apply_immediately
  preferred_maintenance_window = var.preferred_maintenance_window
  instance_class               = var.instance_class
  engine                       = var.engine
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  enable_performance_insights  = var.enable_performance_insights
  ca_cert_identifier           = var.ca_cert_identifier
  tags                         = var.tags
}

resource "aws_docdb_subnet_group" "default" {
   count       = var.enabled? 1 : 0
  name        = var.cluster_identifier
  description = "Allowed subnets for DB cluster instances"
  subnet_ids  = var.subnet_ids
  tags        = var.tags
}

resource "aws_docdb_cluster_parameter_group" "default" {
  count       = var.enabled? 1 : 0
  name        = var.cluster_identifier
  description = "DB cluster parameter group"
  family      = var.cluster_family

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  tags = var.tags
}

