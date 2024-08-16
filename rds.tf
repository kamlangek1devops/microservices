resource "aws_security_group_rule" "allow_ecs_to_rds" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.ecs_sg.id
}



resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.main.*.id #aws_subnet.rds.*.id

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.rds.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  skip_final_snapshot = true

  tags = {
    Name = "mysql-db"
  }
}
