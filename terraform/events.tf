resource "aws_cloudwatch_event_rule" "scheduler" {
  name = "every_10_secs_rule"
  description = "trigger logger every 10 seconds"
  schedule_expression = "rate(2 minutes)"
}

resource "aws_cloudwatch_event_target" "get_quotes_target" {
  rule = aws_cloudwatch_event_rule.scheduler.name
  target_id = "MakeCriticalLog"
  arn = aws_lambda_function.logger.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.logger.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduler.arn
}

resource "aws_cloudwatch_log_metric_filter" "critical_count" {
  name = "CountCriticalLogs"
  log_group_name = aws_cloudwatch_log_group.logger_log_group.name
  pattern = "[CRITICAL]"
  metric_transformation {
    name = "CriticalCounter"
    namespace = "project"
    value = 1
    default_value = 0
  }
}

resource "aws_cloudwatch_metric_alarm" "critical_alarm" {
  alarm_name = "critical-logs"
  metric_name = lookup(aws_cloudwatch_log_metric_filter.critical_count.metric_transformation[0], "name")
  threshold = 1
  statistic = "SampleCount"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 1
  period = 10
  namespace = "project"
#   alarm_actions = [aws_sns_topic.test_topic.arn, aws_lambda_function.publish.arn]
    alarm_actions = [aws_sns_topic.trigger_lambda.arn]
  alarm_description = "Detect a critical log from logger"
  treat_missing_data = "notBreaching"
#   alarm_actions = [aws_lambda_function.publish.arn]
#   metric_query {
#     id="m1"
#     metric {
#       metric_name = "CountCriticalLogs"
#       namespace = "project"
#       period = 30
#       stat = "Sum"
#       unit = "Count"
#     }
#   }
}

# resource "aws_lambda_event_source_mapping" "trigger_publisher" {
#   batch_size = 1
#   event_source_arn = aws_cloudwatch_metric_alarm.critical_alarm.arn
#   enabled = true
#   function_name = aws_lambda_function.publish.function_name
# }