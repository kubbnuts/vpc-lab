resource "aws_s3_bucket" "destination" {
  bucket = "kubbs-tf-test-bucket-destination-12345"
}

resource "aws_s3_bucket_versioning" "destination" {
  bucket = aws_s3_bucket.destination.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "source" {
  provider = aws.west
  bucket   = "kubbs-tf-test-bucket-source-12345"
}

resource "aws_s3_bucket_versioning" "source" {
  provider = aws.west

  bucket = aws_s3_bucket.source.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "replication" {
  name               = "tf-iam-role-replication-12345"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "Stmt1720008025935",
        "Principal": { "Service":"s3.amazonaws.com" }
        "Action": [
          "sts:AssumeRole"
        ],
        "Effect": "Allow",
      },
    ]
  })
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.west
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.source]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.source.id

  rule {
    id = "foobar"

    filter {
      prefix = "foo"
    }

    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }

    delete_marker_replication {
      status = "Enabled"
    }
  }
}
