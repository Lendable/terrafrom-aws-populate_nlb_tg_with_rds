# Creates an alarm that gets triggered whenever there's an IP change.
resource "aws_cloudwatch_metric_alarm" "ip_changes_alarm" {
  alarm_name          = "${var.resource_name_prefix}NLB-TgIp-Changes"
  alarm_description   = "${var.resource_name_prefix}NLB-TgIp-Changes (1 minute sample count)"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "${var.resource_name_prefix}Target_Ip_Changes"
  namespace           = "NLB_Targets_DNS"
  period              = "60"
  evaluation_periods  = "1"
  datapoints_to_alarm = "1"
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
}

# Give permissions to the role of the lambda function. I.e., permissions to send data to a Cloudwatch metric.
data "aws_iam_policy_document" "log_delivery_access_to_namespace" {
  version   = "2012-10-17"
  policy_id = "NLB-to-DNS-Log-Delivery-By-Namespace"
  statement {
    actions   = [
      "cloudwatch:PutMetricData",
    ]
    resources = [
      "*",
    ]
    effect    = "Allow"
    condition {
      test     = "StringEquals"
      variable = "cloudwatch:namespace"
      values   = ["NLB_Targets_DNS"]
    }
  }
}

resource "aws_iam_role_policy" "populate_nlb_tg_with_rds_lambda_log_delivery_ip_changes" {
  name = "${var.resource_name_prefix}populate-nlb-tg-log-delivery-ip-change"
  role = aws_iam_role.populate_nlb_tg_with_rds_lambda.id

  policy = data.aws_iam_policy_document.log_delivery_access_to_namespace.json
}
