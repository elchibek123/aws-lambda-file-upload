data "aws_iam_policy_document" "assume_role_policy_lambda" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/upload_binary.py"
  output_path = "${path.module}/python.zip"
}

data "archive_file" "lambda_query" {
  type        = "zip"
  source_file = "${path.module}/query.py"
  output_path = "${path.module}/query_python.zip"
}

data "aws_iam_policy" "lambda_execute_policy" {
  name = "AWSLambdaExecute"
}

data "aws_caller_identity" "current" {}