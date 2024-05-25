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

data "aws_iam_policy" "s3_policy" {
  name = "AmazonS3FullAccess"
}

data "aws_iam_policy" "cw_logs_policy" {
  name = "CloudWatchLogsFullAccess"
}

data "aws_caller_identity" "current" {}