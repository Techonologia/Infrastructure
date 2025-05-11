#!/bin/bash
set -e
echo 'Creating DevOps platform folder structure...'
echo 'Creating network-module repo structure...'
mkdir -p network-module
mkdir -p network-module
touch network-module/main.tf
mkdir -p network-module
touch network-module/variables.tf
mkdir -p network-module
touch network-module/outputs.tf
cd network-module
git init
git add .
git commit -m "Initial commit"
cd ..

echo 'Creating eks-cluster-module repo structure...'
mkdir -p eks-cluster-module
mkdir -p eks-cluster-module
touch eks-cluster-module/main.tf
mkdir -p eks-cluster-module
touch eks-cluster-module/variables.tf
mkdir -p eks-cluster-module
touch eks-cluster-module/outputs.tf
cd eks-cluster-module
git init
git add .
git commit -m "Initial commit"
cd ..

echo 'Creating github-actions-pipelines repo structure...'
mkdir -p github-actions-pipelines
mkdir -p github-actions-pipelines/.github/workflows
touch github-actions-pipelines/.github/workflows/backend-deploy.yaml
mkdir -p github-actions-pipelines/.github/workflows
touch github-actions-pipelines/.github/workflows/frontend-deploy.yaml
cd github-actions-pipelines
git init
git add .
git commit -m "Initial commit"
cd ..

echo 'Creating helm-charts-app repo structure...'
mkdir -p helm-charts-app
mkdir -p helm-charts-app/charts/app/templates
touch helm-charts-app/charts/app/templates/deployment.yaml
mkdir -p helm-charts-app/charts/app/templates
touch helm-charts-app/charts/app/templates/service.yaml
mkdir -p helm-charts-app/charts/app
touch helm-charts-app/charts/app/values.yaml
mkdir -p helm-charts-app/charts/app
touch helm-charts-app/charts/app/Chart.yaml
cd helm-charts-app
git init
git add .
git commit -m "Initial commit"
cd ..

echo 'Creating k8s-manifests-app repo structure...'
mkdir -p k8s-manifests-app
mkdir -p k8s-manifests-app/dev
touch k8s-manifests-app/dev/backend-deployment.yaml
mkdir -p k8s-manifests-app/dev
touch k8s-manifests-app/dev/backend-service.yaml
mkdir -p k8s-manifests-app/dev
touch k8s-manifests-app/dev/frontend-deployment.yaml
mkdir -p k8s-manifests-app/dev
touch k8s-manifests-app/dev/frontend-service.yaml
cd k8s-manifests-app
git init
git add .
git commit -m "Initial commit"
cd ..

echo 'Creating devops-platform-infra repo structure...'
mkdir -p devops-platform-infra
mkdir -p devops-platform-infra
touch devops-platform-infra/main.tf
mkdir -p devops-platform-infra
touch devops-platform-infra/variables.tf
mkdir -p devops-platform-infra
touch devops-platform-infra/outputs.tf
cd devops-platform-infra
git init
git add .
git commit -m "Initial commit"
cd ..

