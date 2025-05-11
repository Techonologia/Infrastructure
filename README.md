# 🏗️ Infrastructure as Code – Job Marketplace Web App

This repository contains the complete **Infrastructure as Code (IaC)** setup for the **Job Marketplace** platform, which connects clients with local freelancers offering physical services. It manages the provisioning, configuration, deployment, and CI/CD automation of all backend infrastructure components using modern DevOps tools and best practices.

---

## 🧭 Overview

- **Cloud Provider**: Amazon Web Services (AWS)
- **Provisioning Tool**: Terraform
- **Container Orchestration**: Kubernetes (EC2-based self-managed cluster)
- **Package Management**: Helm
- **CI/CD Pipeline**: GitHub Actions
- **Containerization**: Docker

This repository serves as the **single source of truth** for all infrastructure-related configuration and deployment code.

---

## 📂 Repository Structure

```text
infrastructure/
├── terraform/                 # Infrastructure provisioning (VPC, EC2, IAM, etc.)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── backend.tf             # Remote state (S3 + DynamoDB recommended)
│
├── k8s/                       # Kubernetes manifests (raw YAML)
│   ├── app-deployment.yaml
│   ├── app-service.yaml
│   └── ingress.yaml
│
├── helm/                      # Helm chart for deploying app to Kubernetes
│   └── job-market-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           └── ingress.yaml
│
├── docker/                    # Dockerfile(s) for building application container images
│   └── Dockerfile
│
├── .github/
│   └── workflows/             # GitHub Actions CI/CD pipeline definitions
│       └── deploy.yml
│
└── README.md                  # Project documentation (you are here)
```

---

## 🧱 Infrastructure Components

- **VPC & Networking**: Custom Virtual Private Cloud, public/private subnets, NAT Gateway
- **Compute**: EC2 instances for Kubernetes worker nodes (can be auto-scaled)
- **IAM**: Roles and policies for Kubernetes nodes, CI/CD, and secure access
- **Storage**: EBS volumes for pods (if required), S3 bucket for Terraform state
- **Kubernetes Cluster**: Self-managed cluster with `kubeadm`, secured with proper RBAC

---

## 🚀 Deployment Workflow

### 1. Provision Infrastructure

Ensure AWS CLI is configured and Terraform backend (e.g., S3) is set up:

```bash
cd terraform
terraform init
terraform apply
```

---

### 2. Build & Push Docker Image

Handled automatically by GitHub Actions, or manually:

```bash
docker build -t <your-repo>/job-market-app:latest .
docker push <your-repo>/job-market-app:latest
```

---

### 3. Deploy to Kubernetes

#### Option A: Using Raw YAML

```bash
kubectl apply -f k8s/
```

#### Option B: Using Helm

```bash
helm install job-market ./helm/job-market-app
```

> ℹ️ Helm values can be customized in `helm/job-market-app/values.yaml`.

---

## 🔁 CI/CD Pipeline

The `.github/workflows/deploy.yml` workflow automates the following:

- Checkout code on push
- Build Docker image
- Push image to container registry
- Apply Kubernetes manifests using `kubectl` or `helm`

### GitHub Secrets Used

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `KUBECONFIG` or cluster access tokens
- `DOCKER_USERNAME`, `DOCKER_PASSWORD` (if using Docker Hub or similar)

---

## 🔐 Security & Best Practices

- Terraform state is stored remotely (e.g., S3 + DynamoDB) to enable team collaboration
- All secrets and sensitive credentials are stored in **GitHub Secrets**
- IAM roles follow the **principle of least privilege**
- Kubernetes access is **RBAC-controlled**
- Regular scanning of Docker images and dependencies is recommended

---

## 📌 Notes

- This repository manages **infrastructure and deployment only**
- Application source code is maintained in a **separate repository**
- For local development or testing, consider using [minikube](https://minikube.sigs.k8s.io/) or [kind](https://kind.sigs.k8s.io/)

---

## 🧑‍💼 Maintainers

| Name        | Role        | Contact                   |
|-------------|-------------|---------------------------|
| Your Name   | DevOps Lead | your.email@example.com    |

---

## 📝 License

This project is licensed under the [MIT License](LICENSE).

---

## 🙌 Contributions

Contributions and improvements are welcome. Please open an issue or submit a pull request.
