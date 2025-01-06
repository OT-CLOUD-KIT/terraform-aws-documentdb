resource "aws_security_group" "docdb" {
  name_prefix = "${var.cluster_identifier}-docdb-"
  vpc_id      = var.vpc_id
  description = "Security group for DocumentDB cluster ${var.cluster_identifier}"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_identifier}-docdb"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_docdb_subnet_group" "default" {
  name       = var.cluster_identifier
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_docdb_cluster_parameter_group" "default" {
  family = var.cluster_family
  name   = var.cluster_identifier

  parameter {
    name  = "tls"
    value = "enabled"
  }

  parameter {
    name  = "audit_logs"
    value = "enabled"
  }

  parameter {
    name  = "profiler"
    value = "enabled"
  }

  parameter {
    name  = "ttl_monitor"
    value = "enabled"
  }

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = var.tags
}

resource "aws_docdb_cluster" "default" {
  cluster_identifier              = var.cluster_identifier
  engine                         = "docdb"
  engine_version                 = var.engine_version
  master_username                = var.master_username
  master_password                = var.master_password
  backup_retention_period        = var.backup_retention_period
  preferred_backup_window        = var.preferred_backup_window
  skip_final_snapshot           = var.skip_final_snapshot
  deletion_protection           = var.deletion_protection
  db_subnet_group_name          = aws_docdb_subnet_group.default.name
  vpc_security_group_ids        = [aws_security_group.docdb.id]
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.default.name
  storage_encrypted             = var.enable_encryption
  kms_key_id                    = var.kms_key_id

  tags = var.tags
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.number_of_instances
  identifier         = "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier = aws_docdb_cluster.default.id
  instance_class     = var.instance_class
  
  promotion_tier     = lookup(var.instance_promotion_tiers, count.index + 1, var.promotion_tier)
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  
  tags = merge(var.default_tags, var.tags)
}

resource "aws_ssm_parameter" "docdb_master_username" {
  count = var.ssm_parameter_enabled ? 1 : 0
  name  = "/${var.cluster_identifier}/master_username"
  type  = "String"
  value = var.master_username
  tags  = var.tags
}

resource "aws_ssm_parameter" "docdb_master_password" {
  count = var.ssm_parameter_enabled ? 1 : 0
  name  = "/${var.cluster_identifier}/master_password"
  type  = "SecureString"
  value = var.master_password
  tags  = var.tags
} 