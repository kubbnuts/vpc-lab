resource "aws_iam_role" "S3-PublicAccess-TF" {
  name = "S3-PublicAccess-TF"

  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      "Id": "Policy1719330635421",
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "PublicRead",
          "Action": [
            "s3:GetObject",
            "s3:PutBucketPolicy",
            "s3:PutObject"
          ],
         "Effect": "Allow",
         "Resource": "arn:aws:s3:::images/*",
        }
      ]
    })
  }

  #trust policy
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    name = "S3-PublicAccess-TF"
  }
}

resource "aws_s3_bucket" "s3-lab-bucket" {
  bucket = "kubbs-tf-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.s3-lab-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "Public-Read" {
  bucket = aws_s3_bucket.s3-lab-bucket.id
  policy = jsonencode({
      "Id": "Policy1719330635421",
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "PublicRead",
          "Action": [
            "s3:GetObject"
          ],
         "Effect": "Allow",
         "Resource": "arn:aws:s3:::kubbs-tf-test-bucket/*",
         "Principal": "*"
        }
      ]
    })
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.s3-lab-bucket.id

  index_document {
    suffix = "index.html"
  }
}
