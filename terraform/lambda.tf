data "archive_file" "logger" {
  type             = "zip"
  output_file_mode = "0666"
  source_file      = "${path.module}/../src/logger.py"
  output_path      = "${path.module}/../logger.zip"
}

data "archive_file" "publish" {
  type             = "zip"
  output_file_mode = "0666"
  source_file      = "${path.module}/../src/publish.py"
  output_path      = "${path.module}/../publish.zip"
}

resource "aws_lambda_function" "logger" {
  function_name = "critical_logger"
  s3_bucket = aws_s3_bucket.code_bucket.id
  s3_key = aws_s3_object.logger_code.key
  handler = "logger.lambda_handler"
  runtime = var.python_runtime
  source_code_hash = data.archive_file.logger.output_base64sha256
  role = aws_iam_role.lambda_role.arn
  timeout = 12
  logging_config {
    log_format = "Text"
    log_group = aws_cloudwatch_log_group.logger_log_group.name
  }
  depends_on = [ aws_cloudwatch_log_group.logger_log_group ]
}

resource "aws_cloudwatch_log_group" "logger_log_group" {
    name = "logger_log_group"
}

resource "aws_lambda_function" "publish" {
  function_name = "publisher"
  s3_bucket = aws_s3_bucket.code_bucket.id
  s3_key = aws_s3_object.publish_code.key
  handler = "publish.lambda_handler"
  runtime = var.python_runtime
  source_code_hash = data.archive_file.publish.output_base64sha256
  role = aws_iam_role.lambda_role.arn
  timeout = 12
  environment {
    variables = {"sns_topic_arn" = aws_sns_topic.send_email.arn
  }
}
}
