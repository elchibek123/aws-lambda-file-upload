resource "aws_lambda_function" "lambda_function_file_upload" {
  filename      = "${path.module}/python.zip"
  function_name = "file_upload"
  description   = "This function is for uploading files to S3 bucket."
  role          = aws_iam_role.lambda_role.arn
  architectures = ["x86_64"]
  handler       = "upload_binary.lambda_handler"
  runtime       = "python3.11"
  package_type  = "Zip"
  publish       = false

  tags = {
    Name = "file_upload"
  }

  depends_on = [
    aws_iam_role_policy_attachment.s3_policy_attach,
    aws_iam_role_policy_attachment.cw_logs_policy_attach
  ]
}

resource "aws_lambda_permission" "lambda_permission_api_gateway" {
  statement_id  = "AllowMyAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function_file_upload.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.my_api.execution_arn}/*"
}