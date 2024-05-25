resource "aws_lambda_function" "lambda_function_file_upload" {
  filename      = "${path.module}/python.zip"
  function_name = "file_upload"
  description   = "This function is for uploading files to S3 bucket."
  role          = aws_iam_role.lambda_role.arn
  architectures = ["x86_64"]
  handler       = "user_login_detection.lambda_handler"
  runtime       = "python3.11"
  package_type  = "Zip"
  publish       = false

  # environment {
  #   variables = {
  #     SNS_TOPIC_ARN = "${aws_sns_topic.sns_user_login.arn}"
  #   }
  # }

  tags = {
    Name = "file_upload"
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_role_policy_attachment]
}

# resource "aws_lambda_permission" "lambda_allow_eventbridge" {
#   statement_id  = "AllowExecutionFromEventBridge"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.lambda_function_user_login.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.event_rule_console_sign_in.arn
# }