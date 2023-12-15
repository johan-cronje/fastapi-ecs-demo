resource "aws_cloudwatch_log_group" "fastapi-log-group" {
  name              = "/ecs/fastapi-app"
  retention_in_days = var.log_retention_in_days
}
