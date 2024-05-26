resource "aws_iam_role" "lambda_role" {
  name               = "lambda-${var.env}-${var.region}-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_lambda.json

  tags = {
    Name = "lambda-${var.env}-${var.region}-iam-role"
  }
}

# resource "aws_iam_role_policy_attachment" "s3_policy_attach" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = data.aws_iam_policy.s3_policy.arn
# }

# resource "aws_iam_role_policy_attachment" "cw_logs_policy_attach" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = data.aws_iam_policy.cw_logs_policy.arn
# }

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = "s3:PutObject",
        Effect = "Allow",
        Resource = "${aws_s3_bucket.s3_1.arn}/*"
      }
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}