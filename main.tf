provider "aws" {
  region  = "us-east-1"
  profile = "default"
 
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "bucket-s3-api-cep"
  acl    = "public-read"

   website {
  index_document = "index.html"
  error_document = "error.html"
}
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.website_bucket.arn}/*"
        ]
        Principal = "*"
      }
    ]
  })
}



