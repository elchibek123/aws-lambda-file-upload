resource "aws_api_gateway_rest_api" "my_api" {
  name               = "myAPI"
  description        = "This is my API for demonstration purposes"
  binary_media_types = ["application/pdf"]
  endpoint_configuration {
    types = [
      "EDGE"
    ]
  }
}

resource "aws_api_gateway_resource" "resource_upload" {
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "upload"
  rest_api_id = aws_api_gateway_rest_api.my_api.id
}

resource "aws_api_gateway_method" "method_post" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.resource_upload.id
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
}

resource "aws_api_gateway_integration" "integration" {
  http_method             = aws_api_gateway_method.method_post.http_method
  resource_id             = aws_api_gateway_resource.resource_upload.id
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda_function_file_upload.invoke_arn
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/pdf" = jsonencode({
      "content" : "$input.body"
    })
  }

  lifecycle {
    ignore_changes = [request_templates]
  }
}

resource "aws_api_gateway_method_response" "method_response" {
  http_method = aws_api_gateway_method.method_post.http_method
  resource_id = aws_api_gateway_resource.resource_upload.id
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "integration_response" {
  http_method = aws_api_gateway_method.method_post.http_method
  resource_id = aws_api_gateway_resource.resource_upload.id
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  status_code = aws_api_gateway_method_response.method_response.status_code

  depends_on = [
    aws_api_gateway_method.method_post,
    aws_api_gateway_integration.integration
  ]
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.resource_upload.id,
      aws_api_gateway_method.method_post.id,
      aws_api_gateway_integration.integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  stage_name    = var.env
}

resource "aws_api_gateway_rest_api" "api_query" {
  name               = "query"
  description        = "This API is for demonstration purposes"
  binary_media_types = [""]
  endpoint_configuration {
    types = [
      "EDGE"
    ]
  }
}

resource "aws_api_gateway_resource" "resource_query" {
  parent_id   = aws_api_gateway_rest_api.api_query.root_resource_id
  path_part   = "{bucket+}"
  rest_api_id = aws_api_gateway_rest_api.api_query.id
}

resource "aws_api_gateway_method" "method_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.resource_query.id
  rest_api_id   = aws_api_gateway_rest_api.api_query.id
}

resource "aws_api_gateway_integration" "integration_query" {
  http_method             = aws_api_gateway_method.method_get.http_method
  resource_id             = aws_api_gateway_resource.resource_query.id
  rest_api_id             = aws_api_gateway_rest_api.api_query.id
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function_query.invoke_arn
}

# resource "aws_api_gateway_method_response" "method_response_query" {
#   http_method = aws_api_gateway_method.method_get.http_method
#   resource_id = aws_api_gateway_resource.resource_query.id
#   rest_api_id = aws_api_gateway_rest_api.api_query.id
#   status_code = "200"
# }

resource "aws_api_gateway_integration_response" "integration_response_query" {
  http_method = aws_api_gateway_method.method_get.http_method
  resource_id = aws_api_gateway_resource.resource_query.id
  rest_api_id = aws_api_gateway_rest_api.api_query.id
  status_code = aws_api_gateway_method_response.method_response_query.status_code

  depends_on = [
    aws_api_gateway_method.method_get,
    aws_api_gateway_integration.integration_query
  ]
}

resource "aws_api_gateway_deployment" "deployment_query" {
  rest_api_id = aws_api_gateway_rest_api.api_query.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.resource_query.id,
      aws_api_gateway_method.method_get.id,
      aws_api_gateway_integration.integration_query.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage_query" {
  deployment_id = aws_api_gateway_deployment.deployment_query.id
  rest_api_id   = aws_api_gateway_rest_api.api_query.id
  stage_name    = var.env
}