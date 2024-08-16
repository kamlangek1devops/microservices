# Create API Gateway
resource "aws_api_gateway_rest_api" "microservices_rest_api" {
  name        = "api-gateway-${var.project_name}"
  description = "api-gateway-lambda"
}

# Default GET method
resource "aws_api_gateway_method" "default_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.microservices_rest_api.id
  resource_id   = aws_api_gateway_rest_api.microservices_rest_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "default_integration_request" {
  rest_api_id             = aws_api_gateway_rest_api.microservices_rest_api.id
  resource_id             = aws_api_gateway_rest_api.microservices_rest_api.root_resource_id
  http_method             = aws_api_gateway_method.default_get_method.http_method
  credentials             = aws_iam_role.lambda_role.arn
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"

  uri  = aws_lambda_function.microservices_function_default.invoke_arn
  type = "AWS"
}

resource "aws_api_gateway_method_response" "default_method_response" {
  depends_on  = [aws_api_gateway_integration.default_integration_request]
  rest_api_id = aws_api_gateway_rest_api.microservices_rest_api.id
  resource_id = aws_api_gateway_rest_api.microservices_rest_api.root_resource_id
  http_method = "GET"
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type"              = true
    "method.response.header.Strict-Transport-Security" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "default_integration_response" {
  depends_on = [aws_api_gateway_integration.default_integration_request]

  rest_api_id = aws_api_gateway_rest_api.microservices_rest_api.id
  resource_id = aws_api_gateway_rest_api.microservices_rest_api.root_resource_id
  http_method = "GET"
  status_code = aws_api_gateway_method_response.default_method_response.status_code

  response_parameters = {
    "method.response.header.Content-Type"              = "integration.response.header.Content-Type"
    "method.response.header.Strict-Transport-Security" = "'max-age=63072000; includeSubDomains; preload'"
  }

}
#Ending default api#############################################################################################################


# Create /micro_services resource
resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.microservices_rest_api.id
  parent_id   = aws_api_gateway_rest_api.microservices_rest_api.root_resource_id
  count = length(var.microservices)
  path_part   = "${var.microservices[count.index]}" #"api1"
}

resource "aws_api_gateway_method" "api_method_request" {
  rest_api_id   = aws_api_gateway_rest_api.microservices_rest_api.id
  count = length(var.microservices)
  resource_id   = aws_api_gateway_resource.api_resource[count.index].id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.header.Content-Type" = true
  }
}

resource "aws_api_gateway_integration" "api_integration_request" {
  count = length(var.microservices)
  rest_api_id             = aws_api_gateway_rest_api.microservices_rest_api.id
  resource_id             = aws_api_gateway_resource.api_resource[count.index].id
  http_method             = aws_api_gateway_method.api_method_request[count.index].http_method
  credentials             = aws_iam_role.lambda_role.arn
  integration_http_method = "GET" #"POST"
  passthrough_behavior    = "WHEN_NO_MATCH"

  # cache_key_parameters = [
  #   "integration.request.header.Content-Type",
  #   "method.request.header.Content-Type",
  # ]

  # request_parameters = {
  #   "integration.request.header.Content-Type" = "method.request.header.Content-Type"
  # }

  uri  = "http://${aws_lb.main.dns_name}:${var.ports_listener[count.index]}"
  type = "HTTP_PROXY"

  depends_on = [ aws_lb.main ]
}

resource "aws_api_gateway_method_response" "api_method_response" {
  count = length(var.microservices)
  rest_api_id = aws_api_gateway_rest_api.microservices_rest_api.id
  resource_id = aws_api_gateway_resource.api_resource[count.index].id
  http_method = aws_api_gateway_method.api_method_request[count.index].http_method #"GET"
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type"              = true
    "method.response.header.Strict-Transport-Security" = true
  }

  response_models = {
    "application/json" = "Empty"
  }

  depends_on  = [
    aws_api_gateway_method.api_method_request,
    aws_api_gateway_integration.api_integration_request
    ]
}

resource "aws_api_gateway_integration_response" "api_integration_response" {
  count = length(var.microservices)
  rest_api_id = aws_api_gateway_rest_api.microservices_rest_api.id
  resource_id = aws_api_gateway_resource.api_resource[count.index].id
  http_method = aws_api_gateway_method.api_method_request[count.index].http_method #"GET"
  status_code = aws_api_gateway_method_response.api_method_response[count.index].status_code #"200"

  response_parameters = {
    "method.response.header.Content-Type"              = "integration.response.header.Content-Type"
    "method.response.header.Strict-Transport-Security" = "'max-age=63072000; includeSubDomains; preload'"
  }

  depends_on = [
    aws_api_gateway_method.api_method_request,
    aws_api_gateway_integration.api_integration_request,
    aws_api_gateway_method_response.api_method_response
    ]

}

# Deployment Output
resource "aws_api_gateway_deployment" "microservices_deployment" {
  depends_on        = [aws_api_gateway_method_response.default_method_response, 
                       aws_api_gateway_integration_response.default_integration_response, 

                       aws_api_gateway_method.api_method_request,
                       aws_api_gateway_integration.api_integration_request,
                       aws_api_gateway_method_response.api_method_response, 
                       aws_api_gateway_integration_response.api_integration_response]
                       
  rest_api_id       = aws_api_gateway_rest_api.microservices_rest_api.id
  stage_name        = "${terraform.workspace}" # Change this to your desired stage name
  stage_description = "Development Stage"
}
