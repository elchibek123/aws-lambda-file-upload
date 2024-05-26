resource "aws_s3_bucket" "s3_1" {
  bucket        = "private-${var.env}-${var.region}-s3-bucket-001"
  force_destroy = false

  tags = {
    Name = "private-${var.env}-${var.region}-s3-bucket-001"
  }
}

resource "aws_s3_bucket_ownership_controls" "oc_1" {
  bucket = aws_s3_bucket.s3_1.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_blocking_1" {
  bucket                  = aws_s3_bucket.s3_1.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl_1" {
  depends_on = [
    aws_s3_bucket_ownership_controls.oc_1,
    aws_s3_bucket_public_access_block.s3_blocking_1,
  ]

  bucket = aws_s3_bucket.s3_1.id
  acl    = "public"
}

resource "aws_s3_bucket_policy" "bucket_policy_1" {
  bucket = aws_s3_bucket.s3_1.id

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PrivateAccessPolicy"
    Statement = [
      {
        Sid    = "AllowS3Access"
        Effect = "Allow"
        Principal = {
          AWS = [
            "${aws_iam_role.lambda_role.arn}",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/tfc-${var.env}-role"
          ]
        }
        Action = [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Resource = ["arn:aws:s3:::${aws_s3_bucket.s3_1.id}", "arn:aws:s3:::${aws_s3_bucket.s3_1.id}/*"]
      }
    ]
  })
}

resource "aws_s3_bucket_versioning" "s3_versioning_1" {
  bucket = aws_s3_bucket.s3_1.id
  versioning_configuration {
    status = "Disabled"
  }
}