# Create ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${terraform.workspace}-${var.cluster_name}-${var.project_name}"
}

# Create ECS Task Definition
resource "aws_ecs_task_definition" "task_definition" {
  count = length(var.microservices)
  family                   = "task-${var.microservices[count.index]}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name  = "container-${var.microservices[count.index]}"
    image = "${var.images_url[count.index]}"
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]

    environment = [
      {
        name  = "DB_HOST"
        value = "${aws_db_instance.mysql.address}" #aws_db_instance.mysql.endpoint
      },
      {
        name  = "DB_USER"
        value = var.db_username
      },
      {
        name  = "DB_PASS"
        value = var.db_password
      },
      {
        name  = "DB_NAME"
        value = var.db_name
      }
    ]

  }])
}

# Create ECS Service
resource "aws_ecs_service" "ecs_service" {
  count = length(var.microservices)
  name            = "${var.microservices[count.index]}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.task_definition[count.index].arn
  desired_count   = 1
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets         = aws_subnet.main[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_groups[count.index].arn
    container_name   = "container-${var.microservices[count.index]}"
    container_port   = 3000
  }
}