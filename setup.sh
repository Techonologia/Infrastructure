#!/bin/bash

set -e

echo "Creating DevOps platform structure..."

# Define folder structure
mkdir -p app-platform/{terraform/{modules/{network,eks,ec2,rds,iam},environments/{dev,prod}},k8s/{backend,frontend},helm/myapp/{templates,charts},.github/workflows,frontend,backend}

# ------------------- Terraform Files -------------------

# Root Terraform entry
cat > app-platform/terraform/main.tf <<EOF
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
EOF

# Variable definition
cat > app-platform/terraform/variables.tf <<EOF
variable "environment" {
  description = "Environment name (dev or prod)"
  type        = string
}
EOF

# Network module
cat > app-platform/terraform/modules/network/main.tf <<EOF
resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "\${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet("192.168.1.0/24", 4, count.index)
  availability_zone       = "ap-south-1\${element(["a", "b"], count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name = "\${var.environment}-public-\${count.index}"
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
EOF

# EKS module
cat > app-platform/terraform/modules/eks/main.tf <<EOF
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "\${var.environment}-eks-cluster"
  cluster_version = "1.28"
  subnets         = var.subnet_ids
  vpc_id          = var.vpc_id
  enable_irsa     = true
  manage_aws_auth = true
}
EOF

# Dev and Prod env
for env in dev prod; do
cat > app-platform/terraform/environments/$env/main.tf <<EOF
variable "environment" {
  default = "$env"
}

module "platform" {
  source = "../../"
  environment = var.environment
}
EOF
done

# ------------------- GitHub Actions -------------------
cat > app-platform/.github/workflows/deploy.yaml <<EOF
name: Deploy App

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    environment: production

    steps:
    - uses: actions/checkout@v3

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2

    - name: Build and Push Backend
      run: |
        docker build -t my-backend ./backend
        docker tag my-backend my-dockerhub-user/my-backend:latest
        docker push my-dockerhub-user/my-backend:latest

    - name: Build and Push Frontend
      run: |
        docker build -t my-frontend ./frontend
        docker tag my-frontend my-dockerhub-user/my-frontend:latest
        docker push my-dockerhub-user/my-frontend:latest

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: \${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: \${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ap-south-1

    - name: Deploy with Helm
      run: |
        helm upgrade --install myapp ./helm/myapp \
          --set backend.image=my-dockerhub-user/my-backend:latest \
          --set frontend.image=my-dockerhub-user/my-frontend:latest
EOF

# ------------------- Dockerfiles -------------------
cat > app-platform/backend/Dockerfile <<EOF
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
CMD ["npm", "start"]
EOF

cat > app-platform/frontend/Dockerfile <<EOF
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
CMD ["npm", "run", "dev"]
EOF

# ------------------- Helm Chart -------------------
cat > app-platform/helm/myapp/Chart.yaml <<EOF
apiVersion: v2
name: myapp
version: 0.1.0
EOF

cat > app-platform/helm/myapp/values.yaml <<EOF
backend:
  image: my-dockerhub-user/my-backend:latest

frontend:
  image: my-dockerhub-user/my-frontend:latest
EOF

cat > app-platform/helm/myapp/templates/backend-deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
        - name: backend
          image: {{ .Values.backend.image }}
          ports:
            - containerPort: 3000
EOF

cat > app-platform/helm/myapp/templates/frontend-deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: frontend
          image: {{ .Values.frontend.image }}
          ports:
            - containerPort: 3000
EOF

# ------------------- Kubernetes manifests (optional) -------------------
cat > app-platform/k8s/backend/deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
        - name: backend
          image: my-dockerhub-user/my-backend:latest
          ports:
            - containerPort: 3000
EOF

cat > app-platform/k8s/frontend/deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: frontend
          image: my-dockerhub-user/my-frontend:latest
          ports:
            - containerPort: 3000
EOF

echo "✅ All files and folders created in ./app-platform/"

