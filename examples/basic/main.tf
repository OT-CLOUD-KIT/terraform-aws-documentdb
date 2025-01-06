provider "aws" {
  region = "us-west-2"
}

module "docdb_basic" {
  source = "../../"
  
  cluster_identifier = "basic-docdb"
  instance_class    = "db.t3.medium"
  number_of_instances = 1
  
  master_username = "dbadmin"
  master_password = "your-secure-password"
  
  vpc_id = "vpc-xxxxx"
  subnet_ids = ["subnet-xxxxx", "subnet-yyyyy"]
  vpc_cidr_block = "10.0.0.0/16"
  
  deletion_protection = false
  skip_final_snapshot = true
  
  tags = {
    Environment = "development"
  }
} 