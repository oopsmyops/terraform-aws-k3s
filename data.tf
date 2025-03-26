data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}

data "external" "date" {
  program = ["sh", "-c", "date +'{\"stdout\":\"%d-%m-%y\"}'"]
}