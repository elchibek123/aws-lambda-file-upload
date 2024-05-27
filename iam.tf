resource "aws_iam_role" "lambda_role" {
  name               = "lambda-${var.env}-${var.region}-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_lambda.json

  tags = {
    Name = "lambda-${var.env}-${var.region}-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_execute_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.lambda_execute_policy.arn
}