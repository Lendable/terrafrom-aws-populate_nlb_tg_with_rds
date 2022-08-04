output "lambda_80_arn" {
  value = aws_lambda_function.populate_nlb_tg_with_rds_updater_80.arn
}

output "lambda_80_function_name" {
  value = aws_lambda_function.populate_nlb_tg_with_rds_updater_80.function_name
}

output "ip_changes_cloudwatch_alarm_arn" {
  description = "The arm of the cloudwatch alarm that gets triggered whenever the target group changes IP (e.g., when an RDS target goes through a failover"
  value = aws_cloudwatch_metric_alarm.ip_changes_alarm.arn
}
