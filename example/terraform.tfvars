region = "us-east-1"

availability_zones = ["us-east-1a", "us-east-1b"]

vpc_cidr_block = ["10.0.0.0/16"]

subnet_ids = ["subnet-0759f0a3ac70e88c7", "subnet-0d5d2a5274faf7485"]

vpc_id = "vpc-03ddd7fd3163cc23a"

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


skip_final_snapshot = true

apply_immediately = true

ssm_parameter_enabled = true

cluster_identifier = "proddocdb"

deletion_protection= false

env = "dev"
owner = "opstree"
app = "otcloud-kit"


enable_kms              = false
kms_key_id              = null 
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



