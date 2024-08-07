region = "us-east-1"

availability_zones = ["us-east-1a", "us-east-1b"]

vpc_cidr_block = ["172.31.0.0/16"]

subnet_ids = ["subnet-0f115d0114796ab49", "subnet-055d2f5bac51ee0f6"]

vpc_id = "vpc-063ebf4d7094d23fd"

instance_class = "db.t3.medium"

cluster_size = 1

db_port = 27017 #[default portno]

master_username = "documentdb"

master_password = "abcd1234"

retention_period = 5

preferred_backup_window = "07:00-09:00"

cluster_family = "docdb5.0"
engine_version = "5.0.0"

engine = "docdb"

storage_encrypted = true

skip_final_snapshot = true

apply_immediately = true

ssm_parameter_enabled = true

cluster_identifier = "proddocdb"

deletion_protection= false

alias_name              = "documentdb-kms-key"
deletion_window_in_days = 10
is_enabled              = true
enable_key_rotation     = true
tags = {
  Environment = "production"
  Project     = "documentdb"
}
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


