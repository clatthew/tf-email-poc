resource "aws_s3_bucket" "code_bucket" {
  bucket_prefix = var.code_bucket_prefix
  tags = {
    purpose = "quotes lambda function"
  }
}

resource "aws_s3_object" "logger_code" {
  bucket = aws_s3_bucket.code_bucket.id
  key = "logger.zip"
  source = "${path.module}/../logger.zip"
}

resource "aws_s3_object" "publish_code" {
  bucket = aws_s3_bucket.code_bucket.id
  key = "publish.zip"
  source = "${path.module}/../publish.zip"
}