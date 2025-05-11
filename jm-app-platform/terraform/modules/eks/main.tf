module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.environment}-eks-cluster"
  cluster_version = "1.28"
  subnets         = var.subnet_ids
  vpc_id          = var.vpc_id
  enable_irsa     = true
  manage_aws_auth = true
}
