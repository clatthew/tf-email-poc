# ses email template
# ses configuration set
# ses identity

resource "aws_sns_topic" "trigger_lambda" {
  name = "critical-warnings-in-the-logs"
}

resource "aws_sns_topic_subscription" "trigger_lambda" {
  topic_arn = aws_sns_topic.trigger_lambda.arn
    protocol = "lambda"
    endpoint = aws_lambda_function.publish.arn
}

resource "aws_sns_topic" "send_email" {
  name = "critical-warnings-send-email"
}

resource "aws_sns_topic_subscription" "send_email" {
  topic_arn = aws_sns_topic.send_email.arn
  protocol = "email"
  endpoint = file("${path.module}/../email.txt")
}
# https://spin.atomicobject.com/aws-cloudwatch-metric-filter-alarm-terraform/

resource "aws_lambda_permission" "awesome-lambda-perm" {
  statement_id = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.publish.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.trigger_lambda.arn
}