resource "aws_s3_bucket" "s3-storageclasses-bucket" {
  bucket = "kubbs-tf-storageclasses-bucket"

  tags = {
    Name        = "Storage classes bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3-storageclasses-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "example" {
  depends_on = [aws_s3_bucket_versioning.versioning_example]

  bucket = aws_s3_bucket.s3-storageclasses-bucket.id

  rule {
    id = "rule-1"

    filter {
      object_size_greater_than = 131072 # Bytes, equivalent to 128 KB
    }

    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days = 60
      storage_class = "INTELLIGENT_TIERING"
    }

    transition {
      days = 90
      storage_class = "GLACIER_IR"
    }

   transition {
     days = 180
     storage_class = "GLACIER"
   }

   transition {
     days = 365
     storage_class = "DEEP_ARCHIVE"
   }

   noncurrent_version_transition {
     storage_class = "GLACIER"
   }

   noncurrent_version_expiration {
     noncurrent_days = 700
   }

   expiration {
    days = 700
   }

    status = "Enabled"
  }
}
