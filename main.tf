provider "aws" {
  region  = "us-east-1"
 
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "bucket-s3-api-cep"

}


resource "aws_s3_bucket_ownership_controls" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "website_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.website_bucket,
    aws_s3_bucket_public_access_block.website_bucket,
  ]

  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
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


terraform {
  backend "s3" {
    bucket = "buckt-s3-terraform-actions"
    key    = "api-cep/terraform.tfstate"
    region = "us-east-1"
  }
}


resource "aws_s3_bucket_object" "object" {
  bucket = "aws_s3_bucket.website_bucket.bucket"
  key    = "index.html"
  source = "./index.html"
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}



