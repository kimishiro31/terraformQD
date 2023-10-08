
resource "aws_security_group" "sg-rds-prj2023" {
  vpc_id = aws_vpc.vpc-prj2023.id
    name = "SG_RDS_PRJ2023"
  ingress {
    description = "Acesso Interno"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  
  ingress {
    description = "Entrada Instancia"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = []
    security_groups = ["${aws_security_group.sg-elb-prj2023.id}"]
  }

  tags = var.default_tags
}

resource "aws_db_instance" "db_instance_teste" {
  allocated_storage    = 10
  identifier           = "db-instance-teste"
  db_name              = "myBase"
  engine               = "mysql"
  engine_version       = "8.0.33"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "admin123!#"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  multi_az = true
    vpc_security_group_ids = ["${aws_security_group.sg-rds-prj2023.id}"]
  
  db_subnet_group_name = aws_db_subnet_group.dbsubnet.id
  tags = merge(var.default_tags, {
    Name = "rds-prj2023"
  })
}

resource "aws_db_subnet_group" "dbsubnet" {
  name       = "dbsubnet"
  subnet_ids = [aws_subnet.prv-subnet-prj2023-a1.id, aws_subnet.prv-subnet-prj2023-b1.id]
}