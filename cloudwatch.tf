resource "aws_cloudwatch_log_group" "lambda_log" {
  name              = "/aws/lambda/lambda-${var.env}-${var.region}-cw-log"
  retention_in_days = 1
}