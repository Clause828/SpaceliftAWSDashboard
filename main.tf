# modules/cloudwatch-dashboard/main.tf

variable "service_name"    { type = string }
variable "environment"     { type = string }
variable "alb_arn_suffix"  { type = string }
variable "rds_instance_id" { type = string }
variable "owner_team"      { type = string }

locals {
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "ALB Request Count & 5XX"
          region = "us-east-1"
          metrics = [
            ["AWS/ApplicationELB", "RequestCount",    "LoadBalancer", var.alb_arn_suffix],
            [".",                  "HTTPCode_ELB_5XX_Count", ".", "."],
          ]
          stat   = "Sum"
          period = 60
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "ALB Target Latency p95"
          region = "us-east-1"
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_arn_suffix,
              { stat = "p95" }],
          ]
          period = 60
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 24
        height = 6
        properties = {
          title  = "RDS CPU & Connections"
          region = "us-east-1"
          metrics = [
            ["AWS/RDS", "CPUUtilization",     "DBInstanceIdentifier", var.rds_instance_id],
            [".",       "DatabaseConnections", ".",                    "."],
          ]
          period = 300
        }
      },
    ]
  })
}

resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = "${var.service_name}-${var.environment}"
  dashboard_body = local.dashboard_body
}

output "dashboard_url" {
  value = "https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=${aws_cloudwatch_dashboard.this.dashboard_name}"
}