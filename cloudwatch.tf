resource "aws_cloudwatch_log_group" "log" {
  name              = "${var.project}-${var.environment}-logs"
  retention_in_days = local.log_rentation_days
}
