---
layout: default
title: Deployment
nav_order: 8
description: "Production deployment guide for YaniQ platform"
permalink: /DEPLOYMENT/
---

# 🚀 Deployment Guide

<div align="center">

![Deployment](https://img.shields.io/badge/Guide-Deployment-blue?style=for-the-badge)
![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=for-the-badge&logo=docker)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Ready-326CE5?style=for-the-badge&logo=kubernetes)

**Production Deployment Guide for YaniQ E-Commerce Platform**

[Docker](#-docker-deployment) •
[Kubernetes](#-kubernetes-deployment) •
[Cloud Providers](#-cloud-deployment) •
[CI/CD](#-cicd-pipeline) •
[Monitoring](#-monitoring-setup)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Pre-Deployment Checklist](#-pre-deployment-checklist)
- [Docker Deployment](#-docker-deployment)
- [Kubernetes Deployment](#-kubernetes-deployment)
- [Cloud Deployment](#-cloud-deployment)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Monitoring Setup](#-monitoring-setup)
- [Security Hardening](#-security-hardening)
- [Backup & Recovery](#-backup--recovery)
- [Scaling Strategy](#-scaling-strategy)
- [Troubleshooting](#-troubleshooting)

---

## 🌟 Overview

This guide covers production deployment of the YaniQ platform using various deployment strategies and platforms.

### Deployment Options

| Option | Best For | Complexity | Cost |
|--------|----------|------------|------|
| **Docker Compose** | Small teams, development | Low | Low |
| **Kubernetes** | Production, scalability | High | Medium |
| **AWS ECS** | AWS ecosystem | Medium | Medium |
| **Google Cloud Run** | Serverless, auto-scaling | Low | Variable |
| **Azure Kubernetes Service** | Azure ecosystem | Medium | Medium |

---

## ✅ Pre-Deployment Checklist

### Security Checklist

- [ ] **Secrets Management**
  - [ ] JWT secrets generated with strong keys
  - [ ] Database passwords are strong and unique
  - [ ] API keys stored in secret manager
  - [ ] No secrets in source code or config files

- [ ] **SSL/TLS Configuration**
  - [ ] SSL certificates obtained (Let's Encrypt or commercial)
  - [ ] HTTPS enabled on all external endpoints
  - [ ] TLS 1.2+ enforced
  - [ ] Certificate auto-renewal configured

- [ ] **Access Control**
  - [ ] Firewall rules configured
  - [ ] Network policies defined
  - [ ] Database access restricted to application subnet
  - [ ] Admin endpoints secured

### Infrastructure Checklist

- [ ] **Resource Planning**
  - [ ] CPU/Memory requirements calculated
  - [ ] Storage capacity planned
  - [ ] Network bandwidth estimated
  - [ ] Cost analysis completed

- [ ] **High Availability**
  - [ ] Multi-AZ/region deployment planned
  - [ ] Load balancers configured
  - [ ] Database replication enabled
  - [ ] Backup strategy defined

- [ ] **Monitoring & Logging**
  - [ ] Prometheus and Grafana configured
  - [ ] Log aggregation setup (ELK/CloudWatch)
  - [ ] Alerting rules defined
  - [ ] Health checks implemented

### Application Checklist

- [ ] **Configuration**
  - [ ] Production profiles configured
  - [ ] Environment variables documented
  - [ ] Database migrations tested
  - [ ] Cache configuration optimized

- [ ] **Testing**
  - [ ] All tests passing
  - [ ] Load testing completed
  - [ ] Security scanning performed
  - [ ] Performance benchmarks met

---

## 🐳 Docker Deployment

### 1. Build Docker Images

#### Individual Service Build

```bash
# Navigate to service directory
cd apps/discovery-service

# Build Docker image
docker build -t yaniq/discovery-service:1.0.0 .
docker build -t yaniq/discovery-service:latest .

# Verify image
docker images | grep discovery-service
```

#### Multi-Service Build

```bash
# Build all services
docker-compose build

# Build specific services
docker-compose build discovery-service gateway-service auth-service

# Build without cache
docker-compose build --no-cache
```

### 2. Push to Registry

#### Docker Hub

```bash
# Login to Docker Hub
docker login

# Tag images
docker tag yaniq/discovery-service:latest yourusername/yaniq-discovery:1.0.0

# Push images
docker push yourusername/yaniq-discovery:1.0.0
docker push yourusername/yaniq-discovery:latest
```

#### Private Registry

```bash
# Tag for private registry
docker tag yaniq/discovery-service:latest registry.company.com/yaniq/discovery:1.0.0

# Push to private registry
docker push registry.company.com/yaniq/discovery:1.0.0
```

### 3. Docker Compose Production Deployment

**Production docker-compose.yml**:

```yaml
version: '3.8'

services:
  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    restart: always
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_MULTIPLE_DATABASES: auth_db,user_db,product_db,order_db
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./scripts/init-databases.sh:/docker-entrypoint-initdb.d/init-databases.sh
    networks:
      - yaniq-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 30s
      timeout: 10s
      retries: 5
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '1'
          memory: 1G

  # Redis Cache
  redis:
    image: redis:7-alpine
    restart: always
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    networks:
      - yaniq-network
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 30s
      timeout: 10s
      retries: 5

  # Discovery Service
  discovery-service:
    image: yaniq/discovery-service:${VERSION:-latest}
    restart: always
    ports:
      - "8761:8761"
    environment:
      SPRING_PROFILES_ACTIVE: prod
      JAVA_OPTS: -Xmx1g -Xms512m
    networks:
      - yaniq-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8761/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 60s
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: '1'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M

  # API Gateway
  gateway-service:
    image: yaniq/gateway-service:${VERSION:-latest}
    restart: always
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: prod
      EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE: http://discovery-service:8761/eureka/
      REDIS_HOST: redis
      REDIS_PASSWORD: ${REDIS_PASSWORD}
      JAVA_OPTS: -Xmx1g -Xms512m
    depends_on:
      discovery-service:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - yaniq-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 90s
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '2'
          memory: 2G

  # Auth Service
  auth-service:
    image: yaniq/auth-service:${VERSION:-latest}
    restart: always
    environment:
      SPRING_PROFILES_ACTIVE: prod
      EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE: http://discovery-service:8761/eureka/
      DATABASE_URL: jdbc:postgresql://postgres:5432/auth_db
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      JWT_SECRET: ${JWT_SECRET}
      REDIS_HOST: redis
      REDIS_PASSWORD: ${REDIS_PASSWORD}
      JAVA_OPTS: -Xmx1g -Xms512m
    depends_on:
      discovery-service:
        condition: service_healthy
      postgres:
        condition: service_healthy
    networks:
      - yaniq-network
    deploy:
      replicas: 2

networks:
  yaniq-network:
    driver: bridge

volumes:
  postgres_data:
  redis_data:
```

### 4. Deploy with Docker Compose

```bash
# Create .env file
cat > .env << EOF
VERSION=1.0.0
POSTGRES_USER=yaniq
POSTGRES_PASSWORD=$(openssl rand -base64 32)
REDIS_PASSWORD=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 64)
EOF

# Deploy services
docker-compose -f docker-compose.prod.yml up -d

# Check service status
docker-compose -f docker-compose.prod.yml ps

# View logs
docker-compose -f docker-compose.prod.yml logs -f

# Scale specific service
docker-compose -f docker-compose.prod.yml up -d --scale product-service=5
```

---

## ☸️ Kubernetes Deployment

### 1. Prerequisites

```bash
# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Verify installations
kubectl version --client
helm version
```

### 2. Create Namespace

**k8s/namespace.yaml**:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: yaniq
  labels:
    name: yaniq
    environment: production
```

```bash
kubectl apply -f k8s/namespace.yaml
```

### 3. Create ConfigMaps

**k8s/configmaps/application-config.yaml**:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: application-config
  namespace: yaniq
data:
  SPRING_PROFILES_ACTIVE: "prod"
  EUREKA_SERVER_URL: "http://discovery-service:8761/eureka/"
  POSTGRES_HOST: "postgres-service"
  POSTGRES_PORT: "5432"
  REDIS_HOST: "redis-service"
  REDIS_PORT: "6379"
  KAFKA_BOOTSTRAP_SERVERS: "kafka-service:9092"
```

```bash
kubectl apply -f k8s/configmaps/application-config.yaml
```

### 4. Create Secrets

```bash
# Create secrets from literals
kubectl create secret generic postgres-credentials \
  --from-literal=username=yaniq \
  --from-literal=password=$(openssl rand -base64 32) \
  --namespace=yaniq

kubectl create secret generic jwt-secret \
  --from-literal=secret=$(openssl rand -base64 64) \
  --namespace=yaniq

kubectl create secret generic redis-credentials \
  --from-literal=password=$(openssl rand -base64 32) \
  --namespace=yaniq
```

### 5. Deploy PostgreSQL

**k8s/infrastructure/postgres-statefulset.yaml**:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: postgres-service
  namespace: yaniq
spec:
  selector:
    app: postgres
  ports:
    - port: 5432
      targetPort: 5432
  clusterIP: None
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
  namespace: yaniq
spec:
  serviceName: postgres-service
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15-alpine
        ports:
        - containerPort: 5432
        env:
        - name: POSTGRES_USER
          valueFrom:
            secretKeyRef:
              name: postgres-credentials
              key: username
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-credentials
              key: password
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1"
  volumeClaimTemplates:
  - metadata:
      name: postgres-storage
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 20Gi
```

```bash
kubectl apply -f k8s/infrastructure/postgres-statefulset.yaml
```

### 6. Deploy Discovery Service

**k8s/services/discovery-service.yaml**:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: discovery-service
  namespace: yaniq
spec:
  selector:
    app: discovery-service
  ports:
    - port: 8761
      targetPort: 8761
  type: ClusterIP
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: discovery-service
  namespace: yaniq
spec:
  replicas: 2
  selector:
    matchLabels:
      app: discovery-service
  template:
    metadata:
      labels:
        app: discovery-service
    spec:
      containers:
      - name: discovery-service
        image: yaniq/discovery-service:1.0.0
        ports:
        - containerPort: 8761
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "prod"
        - name: JAVA_OPTS
          value: "-Xmx1g -Xms512m -XX:+UseG1GC"
        livenessProbe:
          httpGet:
            path: /actuator/health/liveness
            port: 8761
          initialDelaySeconds: 60
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /actuator/health/readiness
            port: 8761
          initialDelaySeconds: 30
          periodSeconds: 5
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "1Gi"
            cpu: "1"
```

```bash
kubectl apply -f k8s/services/discovery-service.yaml
```

### 7. Deploy Application Services

```bash
# Apply all service deployments
kubectl apply -f k8s/services/

# Check deployment status
kubectl get deployments -n yaniq
kubectl get pods -n yaniq

# Check service endpoints
kubectl get svc -n yaniq
```

### 8. Create Ingress

**k8s/ingress.yaml**:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: yaniq-ingress
  namespace: yaniq
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  tls:
  - hosts:
    - api.yaniq.com
    secretName: yaniq-tls
  rules:
  - host: api.yaniq.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: gateway-service
            port:
              number: 8080
```

```bash
kubectl apply -f k8s/ingress.yaml
```

### 9. Helm Deployment (Alternative)

```bash
# Install YaniQ platform using Helm
helm install yaniq-platform ./helm/yaniq \
  --namespace yaniq \
  --create-namespace \
  --values helm/yaniq/values-prod.yaml

# Upgrade deployment
helm upgrade yaniq-platform ./helm/yaniq \
  --namespace yaniq \
  --values helm/yaniq/values-prod.yaml

# Check deployment status
helm status yaniq-platform -n yaniq

# Rollback if needed
helm rollback yaniq-platform -n yaniq
```

---

## ☁️ Cloud Deployment

### AWS ECS Deployment

```bash
# Install AWS CLI
pip install awscli

# Configure AWS credentials
aws configure

# Create ECR repository
aws ecr create-repository --repository-name yaniq/discovery-service

# Build and push to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com
docker build -t yaniq/discovery-service .
docker tag yaniq/discovery-service:latest <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/yaniq/discovery-service:latest
docker push <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/yaniq/discovery-service:latest

# Deploy to ECS (using task definitions in ci-cd/aws/)
aws ecs create-service --cli-input-json file://ci-cd/aws/ecs-service.json
```

### Google Cloud Run

```bash
# Install gcloud CLI
curl https://sdk.cloud.google.com | bash

# Initialize gcloud
gcloud init

# Build and deploy
gcloud builds submit --tag gcr.io/PROJECT-ID/discovery-service
gcloud run deploy discovery-service \
  --image gcr.io/PROJECT-ID/discovery-service \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

### Azure Kubernetes Service (AKS)

```bash
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Login to Azure
az login

# Create AKS cluster
az aks create \
  --resource-group yaniq-rg \
  --name yaniq-cluster \
  --node-count 3 \
  --enable-managed-identity \
  --generate-ssh-keys

# Get credentials
az aks get-credentials --resource-group yaniq-rg --name yaniq-cluster

# Deploy to AKS
kubectl apply -f k8s/
```

---

## 🔄 CI/CD Pipeline

### Jenkins Pipeline

**Jenkinsfile**:

```groovy
pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'registry.company.com'
        KUBECONFIG = credentials('kubeconfig')
    }
    
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        
        stage('Build Docker Images') {
            steps {
                sh 'docker-compose build'
            }
        }
        
        stage('Push to Registry') {
            steps {
                sh 'docker-compose push'
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/'
            }
        }
    }
    
    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
```

### GitHub Actions

**.github/workflows/deploy.yml**:

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK 21
      uses: actions/setup-java@v3
      with:
        java-version: '21'
        distribution: 'temurin'
    
    - name: Build with Maven
      run: mvn clean install -DskipTests
    
    - name: Run tests
      run: mvn test
    
    - name: Build Docker images
      run: docker-compose build
    
    - name: Push to Docker Hub
      env:
        DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
        DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
      run: |
        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
        docker-compose push
    
    - name: Deploy to Kubernetes
      uses: azure/k8s-deploy@v1
      with:
        manifests: |
          k8s/services/
        images: |
          yaniq/discovery-service:latest
        kubeconfig: ${{ secrets.KUBE_CONFIG }}
```

---

## 📊 Monitoring Setup

### Prometheus Configuration

```bash
# Install Prometheus using Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

### Grafana Dashboards

```bash
# Access Grafana
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

# Login credentials
# Username: admin
# Password: (retrieve from secret)
kubectl get secret -n monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
```

---

## 🔐 Security Hardening

### Network Policies

**k8s/network-policies/default-deny.yaml**:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: yaniq
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

### Pod Security Standards

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: yaniq
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted
```

---

## 💾 Backup & Recovery

### Database Backup

```bash
# Create backup script
cat > backup-postgres.sh << 'EOF'
#!/bin/bash
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
kubectl exec -n yaniq postgres-0 -- pg_dumpall -U yaniq | gzip > backup_${TIMESTAMP}.sql.gz
EOF

chmod +x backup-postgres.sh

# Schedule with cron
crontab -e
# Add: 0 2 * * * /path/to/backup-postgres.sh
```

---

<div align="center">

**Deployment Guide** | **YaniQ E-Commerce Platform**

[⬆ Back to Top](#-deployment-guide) | [📖 Main Documentation](./README.md)

</div>
