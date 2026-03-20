module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  identifier = "${var.prefix}-db"

  engine                     = "postgres"
  engine_version             = "15"
  instance_class             = "db.t4g.micro"
  auto_minor_version_upgrade = true
  family                     = "postgres15"

  allocated_storage   = 5
  skip_final_snapshot = true

  db_name                     = "djangoproject"
  username                    = "djangouser"
  manage_master_user_password = false
  password                    = var.db_password

  multi_az               = false
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.rds_security_group.security_group_id]
}

module "rds_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.prefix}-rds-sg"
  description = "RDS Security Group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within vpc"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]
}
