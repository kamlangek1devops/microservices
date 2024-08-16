# output "load_balancer_dns_name" {
#   value = [aws_lb.main.dns_name]
# }

output "invoke_url" {
  value = aws_api_gateway_deployment.microservices_deployment.invoke_url
}