#!/bin/bash

APP_ROOT="jobmarket-app"
mkdir -p $APP_ROOT
cd $APP_ROOT

echo "Creating folder structure..."

# Terraform Infrastructure
mkdir -p infrastructure/{modules/{network,compute,db,eks,security},envs/{dev,prod}}

# GitHub Actions
mkdir -p .github/workflows

# Dockerfiles
mkdir -p backend frontend
touch backend/Dockerfile frontend/Dockerfile

# Helm Chart
mkdir -p helm/app/templates
touch helm/app/{Chart.yaml,values.yaml}
touch helm/app/templates/{deployment.yaml,service.yaml,ingress.yaml}

# Kubernetes base manifests (optional)
mkdir -p k8s/{dev,prod}
touch k8s/dev/{backend.yaml,frontend.yaml}
touch k8s/prod/{backend.yaml,frontend.yaml}

# Terraform module files
for module in network compute db eks security; do
    touch infrastructure/modules/$module/{main.tf,variables.tf,outputs.tf}
done

# Terraform environment files
for env in dev prod; do
    touch infrastructure/envs/$env/{main.tf,backend.tf,provider.tf,terraform.tfvars}
done

# GitHub Actions
touch .github/workflows/deploy.yml

# README and .gitignore
touch README.md .gitignore

echo "All folders and files created under $APP_ROOT."

