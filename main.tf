resource "aws_docdb_cluster" "docdb_cluster" {
cluster_identifier = "${lower(local.base_name)}-docdb-cluster"
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
  kms_key_id             = var.kms_key_id != null ? var.kms_key_id : null
  port                            = var.db_port
  snapshot_identifier             = var.snapshot_identifier
  db_subnet_group_name            = aws_docdb_subnet_group.docdb_subnet_group.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.docdb_parameter_group.name
  engine                          = var.engine
  engine_version                  = var.engine_version
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  allow_major_version_upgrade     = var.allow_major_version_upgrade
 tags = merge(
    { Name = "${local.base_name}-docdb-cluster" },
    local.common_tags
  )
  }

resource "aws_docdb_cluster_instance" "docdb_cluster_instance" {
  identifier                   = "${lower(local.base_name)}-docdb-instance"
  cluster_identifier           = aws_docdb_cluster.docdb_cluster.id
  apply_immediately            = var.apply_immediately
  preferred_maintenance_window = var.preferred_maintenance_window
  instance_class               = var.instance_class
  engine                       = var.engine
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  enable_performance_insights  = var.enable_performance_insights
  ca_cert_identifier           = var.ca_cert_identifier
 tags = merge(
    { Name = "${local.base_name}-docdb-instance" },
    local.common_tags
  )
  }

resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name        = "${lower(local.base_name)}-docdb-subnet-group"
  description = "Allowed subnets for DB cluster instances"
  subnet_ids  = var.subnet_ids
  tags = merge(
    { Name = "${local.base_name}-docdb-subnet-group" },
    local.common_tags
  )
  }

resource "aws_docdb_cluster_parameter_group" "docdb_parameter_group" {
  name        = "${lower(local.base_name)}-docdb-parameter-group"
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

 tags = merge(
    { Name = "${local.base_name}-docdb-parameter-group" },
    local.common_tags
  )
}


resource "aws_kms_key" "key" {
  count                    = var.enable_kms ? 1 : 0
  description              = "KMS key for ${local.base_name} DocumentDB encryption"
  key_usage                = "ENCRYPT_DECRYPT"
  policy                   = var.kms_policy
  deletion_window_in_days  = var.deletion_window_in_days
  is_enabled               = var.is_enabled
  enable_key_rotation      = var.enable_key_rotation

  tags = merge(
    { "Name" = "${local.base_name}-docdb-kms-key" },
    local.common_tags
  )
}

resource "aws_kms_alias" "key_alias" {
  count         = var.enable_kms ? 1 : 0
  name          = "alias/${local.base_name}-docdb-kms-key"
  target_key_id = aws_kms_key.key[0].key_id
}

