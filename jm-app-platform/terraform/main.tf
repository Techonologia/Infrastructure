terraform {
  required_version = ">= 1.3.0"
  backend "s3" {
    bucket = "your-tfstate-bucket"
    key    = "global/s3/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "network" {
  source = "./modules/network"
  environment = var.environment
}

module "eks" {
  source = "./modules/eks"
  environment = var.environment
  subnet_ids = module.network.public_subnet_ids
  vpc_id     = module.network.vpc_id
}

module "rds" {
  source = "./modules/rds"
  environment = var.environment
  subnet_ids = module.network.db_subnet_ids
  vpc_id     = module.network.vpc_id
}
