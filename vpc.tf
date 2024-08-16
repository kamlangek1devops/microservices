# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.100.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${terraform.workspace}-vpc"
  }
}

# Create Subnets of Apps
resource "aws_subnet" "main" {
  count = length(var.availability_zone_app)
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  #availability_zone = element(data.aws_availability_zones.available.names, count.index)
  availability_zone = "${var.availability_zone_app[count.index]}"

  tags = {
    Name = "${terraform.workspace}-app_subnet"
  }
}

# Create Subnets of DB
# resource "aws_subnet" "rds" {
#   count = length(var.availability_zone_db)
#   vpc_id = aws_vpc.main.id
#   cidr_block = "10.100.5.0/24" #cidrsubnet(aws_vpc.main.cidr_block, 9, count.index)
#   availability_zone = "${var.availability_zone_db[count.index]}"

#   tags = {
#     Name = "${terraform.workspace}-db_subnet"
#   }
# }

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${terraform.workspace}-igw"
  }
}

# Create Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${terraform.workspace}-route_table"
  }
}

# Associate Subnets with Route Table
resource "aws_route_table_association" "a" {
  #count = 2
  count = length(var.availability_zone_app)
  #subnet_id      = element(aws_subnet.main.*.id, count.index)
  subnet_id      = element(aws_subnet.main.*.id, count.index)
  route_table_id = aws_route_table.main.id
}

#data "aws_availability_zones" "available" {}