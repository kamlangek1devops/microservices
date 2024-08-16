# Security Group for the Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "${terraform.workspace}-lb_sg"
  description = "Allow HTTP inbound traffic"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8010
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for the Fargate Service
resource "aws_security_group" "ecs_sg" {
  name        = "${terraform.workspace}-fargate_sg"
  description = "Allow traffic from the load balancer"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3000 #80
    to_port     = 3000 #80
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Load Balancer
resource "aws_lb" "main" {
  name               = "${terraform.workspace}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.main[*].id
}

# Create Target Group
resource "aws_lb_target_group" "lb_target_groups" {
  count = length(var.microservices)
  name     = "${terraform.workspace}-tg-${var.microservices[count.index]}"
  port     = 3000 #80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Create Listener for Load Balancer
resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.main.arn
  count = length(var.ports_listener)
  port              = "${var.ports_listener[count.index]}"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_groups[count.index].arn
  }
}