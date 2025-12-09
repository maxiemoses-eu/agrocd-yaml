StreamlinePay Microservices Deployment Guide

This README provides a comprehensive overview of the StreamlinePay microservices architecture, CI/CD pipeline, Helm chart setup, and GitOps deployment using ArgoCD.

🧩 Microservices Overview

StreamlinePay is composed of four microservices:

products: Java-based product catalog service

user: Python-based user management service

cart: Java-based shopping cart service

store-ui: React-based frontend application

Each service is containerized using Docker and deployed to Kubernetes using Helm charts.

🛠️ Helm Chart Structure

Each microservice has its own Helm chart with the following components:

Chart.yaml: Chart metadata

values.yaml: Configuration values (replica count, image, resources, secrets, etc.)

templates/: Contains Kubernetes manifests for Deployment, Service, ConfigMap, Secret, HPA, and ServiceAccount

Example values.yaml

replicaCount: 2
image:
  repository: your-registry/cart
  tag: latest
  pullPolicy: IfNotPresent
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "250m"
autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 3
  targetCPUUtilizationPercentage: 70
serviceAccount:
  name: cart
configMap:
  API_BASE_URL: "http://product-service.default.svc.cluster.local:8080"
  FEATURE_FLAG: "true"
cartSecret:
  name: cart-chart-secret
  redisKey: redisUri
  jwtKey: jwtSecret

🔐 Secrets Management

Each service uses Kubernetes Secrets to store sensitive data. Secrets are referenced in the Deployment using valueFrom.secretKeyRef.


⚙️ CI/CD Pipeline (Jenkins for the CI)

The Jenkins pipeline performs the following steps:

Checkout: Pulls source code from GitHub

Build & Test: Runs language-specific tests for each microservice

Docker Build: Builds Docker images for each service

Trivy Scan: Scans images for vulnerabilities (HIGH/CRITICAL)

Push to ECR: Tags and pushes images to AWS ECR

GitOps Promotion: Updates image tags in GitOps repo and pushes changes

🚀 GitOps with ArgoCD

ArgoCD watches the GitOps repo (agrocd-yaml) and automatically syncs changes to the cluster.

ArgoCD Application Manifest

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: cart
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/maxiemoses-eu/agrocd-yaml.git
    targetRevision: main
    path: cart
  destination:
    server: https://kubernetes.default.svc
    namespace: cart
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true

The same process is REPEATED for the other microservice application with appropriate paths and namespaces.

📊 Monitoring & Autoscaling

Horizontal Pod Autoscaler (HPA) is enabled for each service.

Prometheus & Grafana recommended for metrics and dashboards.

ELK/EFK stack or CloudWatch for centralized logging.

✅ Final Checklist

[x] Helm charts validated and installed

[x] Secrets securely referenced

[x] Jenkins pipeline integrated with Trivy and GitOps

[x] ArgoCD syncing GitOps repo

[x] Autoscaling and monitoring in place

📂 Repo Structure

agrocd-yaml/
├── cart/
├── products/
├── user/
|── store-ui/
└── applications/
    ├── cart-app.yaml
    ├── products-app.yaml
    └── user-app.yaml
    └── store-ui-app.yaml

🧠 Next Steps

Integrate SealedSecrets or AWS Secrets Manager

Add alerting via Prometheus Alertmanager

Enable ingress and TLS for public-facing services

For questions or contributions, contact Maxie Moses Adams or open an issue in the GitHub repo.