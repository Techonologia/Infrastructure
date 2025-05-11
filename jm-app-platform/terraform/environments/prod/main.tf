variable "environment" {
  default = "prod"
}

module "platform" {
  source = "../../"
  environment = var.environment
}
