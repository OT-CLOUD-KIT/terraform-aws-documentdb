provider "aws" {
  region = "us-west-2"
}

module "docdb_production" {
  source = "../../"
  
  cluster_identifier = "prod-docdb"
  instance_class    = "db.r5.large"
  number_of_instances = 3
  
  master_username = "dbadmin"
  master_password = "your-secure-password"
  
  vpc_id = "vpc-xxxxx"
  subnet_ids = ["subnet-xxxxx", "subnet-yyyyy"]
  vpc_cidr_block = "10.0.0.0/16"
  
  backup_retention_period = 14
  preferred_backup_window = "03:00-04:00"
  preferred_maintenance_window = "sun:05:00-sun:06:00"
  
  enable_encryption = true
  enable_cloudwatch_logs_exports = ["audit", "profiler"]
  enable_performance_insights = true
  
  ssm_parameter_enabled = true
  
  cluster_parameters = [
    {
      name  = "tls"
      value = "enabled"
    },
    {
      name  = "ttl_monitor"
      value = "enabled"
    }
  ]
  
  tags = {
    Environment = "production"
    Project     = "main"
  }
} 