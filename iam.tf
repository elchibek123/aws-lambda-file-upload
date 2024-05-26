resource "aws_iam_role" "lambda_role" {
  name               = "lambda-${var.env}-${var.region}-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_lambda.json

  tags = {
    Name = "lambda-${var.env}-${var.region}-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "s3_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "cw_logs_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.cw_logs_policy.arn
}