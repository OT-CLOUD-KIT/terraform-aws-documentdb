resource "aws_security_group" "default" {
  count       = var.enabled? 1 : 0
  name        = var.cluster_identifier
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_security_group_rule" "egress" {
  count             = var.enabled? 1 : 0
  type              = "egress"
  from_port         = var.egress_from_port
  to_port           = var.egress_to_port
  protocol          = var.egress_protocol
  cidr_blocks       = var.allowed_egress_cidr_blocks
  security_group_id = join("", aws_security_group.default[*].id)
}

resource "aws_security_group_rule" "allow_ingress_from_self" {
  count             = var.enabled&& var.allow_ingress_from_self ? 1 : 0
  type              = "ingress"
  from_port         = var.db_port
  to_port           = var.db_port
  protocol          = "tcp"
  security_group_id = join("", aws_security_group.default[*].id)
  self              = true
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                    = var.enabled? length(var.allowed_security_groups) : 0
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_groups, count.index)
  security_group_id        = join("", aws_security_group.default[*].id)
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  type              = "ingress"
  count             = var.enabled&& length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  from_port         = var.db_port
  to_port           = var.db_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.default[*].id)
}

resource "random_password" "password" {
  count   = var.enabled&& var.master_password == "" ? 1 : 0
  length  = 16
  special = false
}

resource "aws_docdb_cluster" "default" {
  count                           = var.enabled? 1 : 0
  cluster_identifier              = var.cluster_identifier
  master_username                 = var.master_username
  master_password                 = var.master_password != "" ? var.master_password : random_password.password[0].result
  backup_retention_period         = var.retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  final_snapshot_identifier       = lower(var.cluster_identifier)
  skip_final_snapshot             = var.skip_final_snapshot
  deletion_protection             = var.deletion_protection
  apply_immediately               = var.apply_immediately
  storage_encrypted               = var.storage_encrypted
  storage_type                    = var.storage_type
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

