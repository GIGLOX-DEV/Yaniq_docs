# 🚀 Getting Started Guide

<div align="center">

![Getting Started](https://img.shields.io/badge/Guide-Getting%20Started-blue?style=for-the-badge)
![Difficulty](https://img.shields.io/badge/Difficulty-Beginner-green?style=for-the-badge)
![Time](https://img.shields.io/badge/Time-30%20minutes-orange?style=for-the-badge)

**Quick Setup Guide for YaniQ E-Commerce Platform**

[Prerequisites](#-prerequisites) •
[Installation](#-installation) •
[Running Services](#-running-services) •
[Verification](#-verification) •
[Next Steps](#-next-steps)

</div>

---

## 📋 Table of Contents

- [Prerequisites](#-prerequisites)
- [System Requirements](#-system-requirements)
- [Installation Methods](#-installation-methods)
- [Quick Start](#-quick-start)
- [Running Individual Services](#-running-individual-services)
- [Docker Deployment](#-docker-deployment)
- [Kubernetes Deployment](#-kubernetes-deployment)
- [Verification](#-verification)
- [Common Issues](#-common-issues)
- [Next Steps](#-next-steps)

---

## 📦 Prerequisites

### Required Software

Before you begin, ensure you have the following installed:

#### 1. Java Development Kit (JDK) 21

```bash
# Check Java version
java -version

# Expected output:
# openjdk version "21.x.x"
```

**Installation**:
- **macOS**: `brew install openjdk@21`
- **Ubuntu/Debian**: `sudo apt install openjdk-21-jdk`
- **Windows**: Download from [Adoptium](https://adoptium.net/)

#### 2. Apache Maven 3.8+

```bash
# Check Maven version
mvn -version

# Expected output:
# Apache Maven 3.8.x or higher
```

**Installation**:
- **macOS**: `brew install maven`
- **Ubuntu/Debian**: `sudo apt install maven`
- **Windows**: Download from [Maven Official Site](https://maven.apache.org/)

#### 3. Docker & Docker Compose

```bash
# Check Docker version
docker --version
docker-compose --version

# Expected output:
# Docker version 24.x.x or higher
# docker-compose version 1.29.x or higher
```

**Installation**:
- **macOS**: [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)
- **Ubuntu/Debian**: [Docker Engine](https://docs.docker.com/engine/install/ubuntu/)
- **Windows**: [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/)

#### 4. Git

```bash
# Check Git version
git --version
```

**Installation**:
- **macOS**: `brew install git`
- **Ubuntu/Debian**: `sudo apt install git`
- **Windows**: Download from [Git Official Site](https://git-scm.com/)

### Optional Tools

- **PostgreSQL Client** - For database management
- **Redis CLI** - For cache inspection
- **Kafka Tools** - For event monitoring
- **Postman/Insomnia** - For API testing
- **IntelliJ IDEA / VSCode** - For development

---

## 💻 System Requirements

### Minimum Requirements

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| **CPU** | 4 cores | 8+ cores |
| **RAM** | 8 GB | 16+ GB |
| **Disk Space** | 20 GB | 50+ GB |
| **OS** | Windows 10, macOS 11, Ubuntu 20.04 | Latest versions |

### Port Requirements

Ensure the following ports are available:

| Port | Service | Status |
|------|---------|--------|
| 8761 | Discovery Service | ✅ Required |
| 8080 | API Gateway | ✅ Required |
| 8081 | Auth Service | 🔄 Optional |
| 8082 | User Service | 🔄 Optional |
| 8083 | Product Service | 🔄 Optional |
| 8084 | Order Service | 🔄 Optional |
| 8085 | Payment Service | 🔄 Optional |
| 8086 | Cart Service | 🔄 Optional |
| 8087 | Inventory Service | 🔄 Optional |
| 8088 | Notification Service | 🔄 Optional |
| 8089 | Analytics Service | 🔄 Optional |
| 5432 | PostgreSQL | 🔄 If using Docker |
| 6379 | Redis | 🔄 If using Docker |
| 9092 | Kafka | 🔄 If using Docker |

---

## 🎯 Installation Methods

Choose your preferred installation method:

### Method 1: Local Development (Recommended for Development)
- Run services directly on your machine
- Easier debugging and development
- Direct access to logs

### Method 2: Docker Compose (Recommended for Testing)
- All services in containers
- Consistent environment
- Easy setup and teardown

### Method 3: Kubernetes (Recommended for Production)
- Production-like environment
- Scalability testing
- Full orchestration

---

## ⚡ Quick Start

### Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/yaniq/yaniq-monorepo.git

# Navigate to project directory
cd yaniq-monorepo

# Check repository structure
ls -la
```

### Step 2: Configure Environment

```bash
# Copy example environment file
cp example.env .env

# Edit environment variables (optional)
nano .env
```

**Basic .env configuration**:
```env
# Application
SPRING_PROFILES_ACTIVE=dev
LOG_LEVEL=INFO

# Database
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=yaniq
POSTGRES_PASSWORD=changeme

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# Kafka
KAFKA_BOOTSTRAP_SERVERS=localhost:9092

# Security
JWT_SECRET=your-secret-key-change-in-production
JWT_EXPIRATION=86400000

# Discovery Service
EUREKA_SERVER_URL=http://localhost:8761/eureka/
```

### Step 3: Start Infrastructure Services

```bash
# Start PostgreSQL, Redis, and Kafka using Docker Compose
docker-compose up -d postgres redis kafka

# Wait for services to be ready (about 30 seconds)
docker-compose ps

# Check logs if needed
docker-compose logs -f postgres
```

### Step 4: Build the Project

```bash
# Build all services (skip tests for faster build)
mvn clean install -DskipTests

# Or build with tests
mvn clean install

# Build specific service
cd apps/discovery-service
mvn clean install
```

### Step 5: Start Discovery Service (REQUIRED FIRST)

The Discovery Service must be started first as other services depend on it.

```bash
# Navigate to discovery service
cd apps/discovery-service

# Run the service
mvn spring-boot:run

# Wait for startup message:
# "Started DiscoveryServiceApplication in X seconds"
```

**Verify Discovery Service**:
- Open browser: http://localhost:8761
- You should see the Eureka dashboard

### Step 6: Start API Gateway

```bash
# Open new terminal
cd apps/gateway-service

# Run the service
mvn spring-boot:run

# Wait for registration with Eureka (30-60 seconds)
```

### Step 7: Start Additional Services

Start services based on your needs:

```bash
# Auth Service (Terminal 3)
cd apps/auth-service
mvn spring-boot:run

# User Service (Terminal 4)
cd apps/user-service
mvn spring-boot:run

# Product Service (Terminal 5)
cd apps/product-service
mvn spring-boot:run

# Continue with other services as needed...
```

---

## 🔧 Running Individual Services

### Service Startup Order

For optimal startup, follow this order:

1. **Infrastructure** (PostgreSQL, Redis, Kafka)
2. **Discovery Service** (Port 8761) - WAIT for full startup
3. **API Gateway** (Port 8080) - WAIT for Eureka registration
4. **Auth Service** (Port 8081)
5. **Core Services** (User, Product, etc.)
6. **Business Services** (Order, Payment, etc.)

### Running Discovery Service

```bash
cd apps/discovery-service

# Option 1: Using Maven
mvn spring-boot:run

# Option 2: Using Java
mvn clean package -DskipTests
java -jar target/discovery-service-0.0.1-SNAPSHOT.jar

# Option 3: With specific profile
mvn spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=dev

# Option 4: With custom port
mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8761
```

### Running Gateway Service

```bash
cd apps/gateway-service
mvn spring-boot:run

# With custom configuration
mvn spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=dev --eureka.client.service-url.defaultZone=http://localhost:8761/eureka/"
```

### Running Auth Service

```bash
cd apps/auth-service
mvn spring-boot:run

# Check logs for successful registration
# Look for: "DiscoveryClient... registering service AUTH-SERVICE"
```

---

## 🐳 Docker Deployment

### Option 1: Docker Compose (All Services)

```bash
# Build all Docker images
docker-compose build

# Start all services
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f discovery-service

# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Option 2: Docker Compose (Selective Services)

```bash
# Start only infrastructure
docker-compose up -d postgres redis kafka

# Start core services
docker-compose up -d discovery-service gateway-service auth-service

# Scale specific service
docker-compose up -d --scale product-service=3

# Check scaled instances
docker-compose ps product-service
```

### Option 3: Individual Docker Containers

```bash
# Build Discovery Service image
cd apps/discovery-service
docker build -t yaniq/discovery-service:latest .

# Run Discovery Service container
docker run -d \
  --name discovery-service \
  -p 8761:8761 \
  -e SPRING_PROFILES_ACTIVE=prod \
  yaniq/discovery-service:latest

# Check container logs
docker logs -f discovery-service

# Stop container
docker stop discovery-service

# Remove container
docker rm discovery-service
```

### Docker Compose File Structure

**docker-compose.yml** (main file):
```yaml
version: '3.8'

services:
  # Infrastructure
  postgres:
    image: postgres:15-alpine
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: yaniq
      POSTGRES_PASSWORD: changeme
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U yaniq"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5

  # Discovery Service
  discovery-service:
    build: ./apps/discovery-service
    ports:
      - "8761:8761"
    environment:
      SPRING_PROFILES_ACTIVE: docker
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8761/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Gateway Service
  gateway-service:
    build: ./apps/gateway-service
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE: http://discovery-service:8761/eureka/
    depends_on:
      discovery-service:
        condition: service_healthy

volumes:
  postgres_data:
```

---

## ☸️ Kubernetes Deployment

### Prerequisites

- Kubernetes cluster (Minikube, Kind, or cloud provider)
- kubectl CLI installed and configured
- Helm 3.x (optional)

### Option 1: Using kubectl

```bash
# Apply namespace
kubectl create namespace yaniq

# Apply ConfigMaps and Secrets
kubectl apply -f k8s/configmaps/ -n yaniq
kubectl apply -f k8s/secrets/ -n yaniq

# Deploy infrastructure
kubectl apply -f k8s/infrastructure/ -n yaniq

# Wait for infrastructure to be ready
kubectl wait --for=condition=ready pod -l app=postgres -n yaniq --timeout=300s

# Deploy Discovery Service
kubectl apply -f k8s/services/discovery-service.yml -n yaniq

# Wait for Discovery Service
kubectl wait --for=condition=ready pod -l app=discovery-service -n yaniq --timeout=300s

# Deploy other services
kubectl apply -f k8s/services/ -n yaniq

# Check deployment status
kubectl get pods -n yaniq
kubectl get services -n yaniq
kubectl get ingress -n yaniq
```

### Option 2: Using Helm

```bash
# Add Helm repository (if custom charts)
helm repo add yaniq ./helm/yaniq
helm repo update

# Install with Helm
helm install yaniq-platform yaniq/yaniq \
  --namespace yaniq \
  --create-namespace \
  --values helm/yaniq/values.yaml

# Check deployment
helm list -n yaniq
kubectl get pods -n yaniq

# Upgrade deployment
helm upgrade yaniq-platform yaniq/yaniq \
  --namespace yaniq \
  --values helm/yaniq/values.yaml

# Uninstall
helm uninstall yaniq-platform -n yaniq
```

### Accessing Services in Kubernetes

```bash
# Port forward Discovery Service
kubectl port-forward svc/discovery-service 8761:8761 -n yaniq

# Port forward API Gateway
kubectl port-forward svc/gateway-service 8080:8080 -n yaniq

# Access via Ingress (if configured)
kubectl get ingress -n yaniq
```

---

## ✅ Verification

### 1. Check Discovery Service

```bash
# Health check
curl http://localhost:8761/actuator/health

# Expected response:
# {"status":"UP"}

# Check registered services
curl http://localhost:8761/eureka/apps -H "Accept: application/json"
```

**Browser verification**:
- Open: http://localhost:8761
- Should see Eureka dashboard with registered services

### 2. Check API Gateway

```bash
# Health check
curl http://localhost:8080/actuator/health

# Check routes
curl http://localhost:8080/actuator/gateway/routes
```

### 3. Test Service Communication

```bash
# Test Auth Service via Gateway
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# Test Product Service via Gateway
curl http://localhost:8080/api/products
```

### 4. Check Infrastructure

```bash
# Test PostgreSQL connection
docker exec -it postgres psql -U yaniq -c "SELECT version();"

# Test Redis connection
docker exec -it redis redis-cli ping
# Expected: PONG

# Test Kafka
docker exec -it kafka kafka-topics.sh --list --bootstrap-server localhost:9092
```

### 5. Monitoring Endpoints

Each service provides actuator endpoints:

```bash
# Health
curl http://localhost:8081/actuator/health

# Metrics
curl http://localhost:8081/actuator/metrics

# Info
curl http://localhost:8081/actuator/info

# Prometheus metrics
curl http://localhost:8081/actuator/prometheus
```

---

## 🔍 Common Issues

### Issue 1: Port Already in Use

**Error**: `Port 8761 is already in use`

**Solution**:
```bash
# Find process using the port
lsof -i :8761  # macOS/Linux
netstat -ano | findstr :8761  # Windows

# Kill the process
kill -9 <PID>  # macOS/Linux
taskkill /PID <PID> /F  # Windows
```

### Issue 2: Service Not Registering with Eureka

**Symptoms**: Service doesn't appear in Eureka dashboard

**Solutions**:
1. Verify Eureka URL in application.yml
2. Check network connectivity
3. Wait 30-60 seconds for registration
4. Check service logs for errors
5. Verify `eureka.client.register-with-eureka=true`

### Issue 3: Database Connection Errors

**Error**: `Unable to connect to PostgreSQL`

**Solutions**:
```bash
# Check if PostgreSQL is running
docker ps | grep postgres

# Check PostgreSQL logs
docker logs postgres

# Verify connection settings
docker exec -it postgres psql -U yaniq -c "\l"

# Restart PostgreSQL
docker-compose restart postgres
```

### Issue 4: Out of Memory Errors

**Error**: `java.lang.OutOfMemoryError: Java heap space`

**Solutions**:
```bash
# Increase JVM heap size
export MAVEN_OPTS="-Xmx2048m"
mvn spring-boot:run

# Or when running JAR
java -Xmx2g -Xms512m -jar target/service.jar
```

### Issue 5: Docker Build Failures

**Error**: `Failed to build Docker image`

**Solutions**:
```bash
# Clean Docker cache
docker system prune -a

# Build without cache
docker-compose build --no-cache

# Check Docker resources
docker system df
```

### Issue 6: Maven Build Errors

**Error**: `Failed to execute goal`

**Solutions**:
```bash
# Clean Maven cache
mvn clean

# Force update dependencies
mvn clean install -U

# Skip tests
mvn clean install -DskipTests

# Clear local repository (last resort)
rm -rf ~/.m2/repository/com/yaniq
```

---

## 🎯 Next Steps

### For Developers

1. **Explore the codebase**
   - Read [Architecture Documentation](./ARCHITECTURE.md)
   - Review service implementations
   - Check common libraries

2. **Set up your IDE**
   - Import as Maven project
   - Configure code style
   - Install recommended plugins

3. **Start developing**
   - Read [Contributing Guidelines](./CONTRIBUTING.md)
   - Choose a service to work on
   - Create a feature branch

4. **Write tests**
   - Unit tests with JUnit 5
   - Integration tests with TestContainers
   - API tests with REST Assured

### For Operations

1. **Configure monitoring**
   - Set up Prometheus and Grafana
   - Configure alerting rules
   - Set up log aggregation

2. **Prepare for production**
   - Review [Deployment Guide](./DEPLOYMENT.md)
   - Configure secrets management
   - Set up CI/CD pipelines

3. **Performance tuning**
   - JVM optimization
   - Database tuning
   - Cache configuration

### Learning Resources

- 📖 **[Service Documentation](./services/)** - Detailed service guides
- 🏗️ **[Architecture Guide](./ARCHITECTURE.md)** - System architecture
- ⚙️ **[Configuration Guide](./CONFIGURATION.md)** - Configuration management
- 🔧 **[Troubleshooting Guide](./TROUBLESHOOTING.md)** - Common issues
- 🌐 **[API Documentation](SWAGGER_DOCUMENTATION.md)** - Interactive API docs

---

## 📞 Getting Help

- 🐛 **Report Issues**: [GitHub Issues](https://github.com/yaniq/yaniq-monorepo/issues)
- 💬 **Ask Questions**: [GitHub Discussions](https://github.com/yaniq/yaniq-monorepo/discussions)
- 📧 **Email**: danukajihansanath0408@gmail.com
- 📚 **Documentation**: [Full Documentation](./README.md)

---

<div align="center">

**Getting Started Guide** | **YaniQ E-Commerce Platform**

[⬆ Back to Top](#-getting-started-guide) | [📖 Main Documentation](./README.md)

</div>

