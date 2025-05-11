variable "environment" {
  default = "dev"
}

module "platform" {
  source = "../../"
  environment = var.environment
}
