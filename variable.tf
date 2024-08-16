variable "project_name" {
  type = string
  default = "DevOps"
}

variable "aws_region" {
  description = "AWS region for deployment"
  default     = "us-east-1"
}

variable "availability_zone_app" {
  type = list(string)
  default = [ "us-east-1a", "us-east-1b" ]
}

variable "availability_zone_db" {
  type = list(string)
  default = [ "us-east-1a" ]
}

variable "cluster_name" {
  type = string
  default = "demo"
}

variable "microservices" {
  description = "List of microservices paths"
  type = list(string)
  default = [
    "api1"
    ,"api2"
    , "api3"
  ]
}

variable "ports_listener" {
  description = "Listener port"
  type = list(number)
  default = [ 
    8001
    , 8002
    , 8003 
  ]
}

variable "images_url" {
  description = "Containner image"
  type = list(string)
  default = [
    "kamlangek2devops/app1:2.0.1"
    , "kamlangek2devops/app2:2.0.1"
    , "kamlangek2devops/app3:2.0.1"
  ]
}

variable "db_name" {
  type = string
  default = "MY_DB"
}

variable "db_username" {
  type = string
  default = "admin"
}

variable "db_password" {
  type = string
  default = "PWD123456"
}