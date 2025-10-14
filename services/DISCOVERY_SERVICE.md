# 🔍 Discovery Service Documentation

<div align="center">

![Service Status](https://img.shields.io/badge/Status-Production%20Ready-success?style=for-the-badge)
![Spring Cloud](https://img.shields.io/badge/Spring%20Cloud-Netflix%20Eureka-green?style=for-the-badge)
![Port](https://img.shields.io/badge/Port-8761-blue?style=for-the-badge)

**Service Registry & Discovery for YaniQ Microservices**

[Overview](#-overview) •
[Architecture](#-architecture) •
[Configuration](#-configuration) •
[API Reference](#-api-reference) •
[Monitoring](#-monitoring)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Architecture](#-architecture)
- [Technology Stack](#-technology-stack)
- [Configuration](#-configuration)
- [Getting Started](#-getting-started)
- [API Reference](#-api-reference)
- [Monitoring & Health](#-monitoring--health)
- [High Availability](#-high-availability)
- [Troubleshooting](#-troubleshooting)
- [Production Deployment](#-production-deployment)

---

## 🌟 Overview

The **Discovery Service** is the heart of the YaniQ microservices architecture, built on **Netflix Eureka Server**. It provides dynamic service registration and discovery, enabling microservices to find and communicate with each other without hard-coded endpoints.

### Why Eureka?

- ✅ **Dynamic Service Discovery** - Services register themselves automatically
- 🔄 **Self-Healing** - Automatic removal of unhealthy instances
- ⚖️ **Load Balancing** - Client-side load balancing support
- 🎯 **Zone Awareness** - Multi-zone deployment support
- 📊 **Real-time Dashboard** - Visual monitoring of registered services
- 🚀 **Production-Ready** - Battle-tested by Netflix at scale

---

## 🎯 Key Features

### Core Capabilities

✅ **Service Registration**
- Automatic service registration on startup
- Heartbeat mechanism for health monitoring
- Metadata support for custom attributes

✅ **Service Discovery**
- Real-time service instance lookup
- Support for multiple instances per service
- Zone-aware routing

✅ **Health Monitoring**
- Automatic health checks via heartbeats
- Configurable eviction policies
- Self-preservation mode for network partitions

✅ **Dashboard UI**
- Web-based service registry viewer
- Instance status monitoring
- System information display

✅ **High Availability**
- Peer-to-peer replication support
- Multi-instance cluster configuration
- Resilience during network failures

---

## 🏗️ Architecture

### Service Discovery Flow

```mermaid
sequenceDiagram
    participant MS as Microservice
    participant ES as Eureka Server
    participant GW as API Gateway
    participant Client as Client Service

    Note over MS,ES: Service Registration
    MS->>ES: Register (Service Name, IP, Port, Metadata)
    ES-->>MS: Registration Confirmed
    MS->>ES: Heartbeat (every 30s)
    
    Note over GW,ES: Service Discovery
    GW->>ES: Fetch Service Registry
    ES-->>GW: Return All Services
    
    Note over Client,GW: Service Communication
    Client->>GW: Request to Service X
    GW->>GW: Lookup Service X from Cache
    GW->>MS: Route Request
    MS-->>GW: Response
    GW-->>Client: Forward Response
    
    Note over MS,ES: Health Check Failure
    MS-xES: Heartbeat Timeout (90s)
    ES->>ES: Mark Instance as DOWN
    ES->>ES: Evict Instance (after 90s)
```

### Component Architecture

```mermaid
flowchart TB
    subgraph "Eureka Server - Port 8761"
        direction TB
        WEB[Web Dashboard]
        REG[Service Registry]
        HEALTH[Health Monitor]
        API[REST API]
        CACHE[Response Cache]
    end

    subgraph "Microservices"
        AUTH[Auth Service<br/>8081]
        USER[User Service<br/>8082]
        PRODUCT[Product Service<br/>8083]
        ORDER[Order Service<br/>8084]
        GATEWAY[Gateway Service<br/>8080]
    end

    AUTH -.->|Register| REG
    USER -.->|Register| REG
    PRODUCT -.->|Register| REG
    ORDER -.->|Register| REG
    
    AUTH -.->|Heartbeat| HEALTH
    USER -.->|Heartbeat| HEALTH
    PRODUCT -.->|Heartbeat| HEALTH
    ORDER -.->|Heartbeat| HEALTH
    
    GATEWAY -->|Discover Services| API
    API --> CACHE
    CACHE --> REG
    
    WEB --> REG
    HEALTH --> REG

    style REG fill:#00FF00,stroke:#006400,stroke-width:3px
    style HEALTH fill:#FFD700,stroke:#FF8C00,stroke-width:2px
    style GATEWAY fill:#87CEEB,stroke:#4682B4,stroke-width:2px
```

---

## 🛠️ Technology Stack

| Component | Technology | Version |
|-----------|------------|---------|
| **Framework** | Spring Boot | 3.5.5 |
| **Cloud Framework** | Spring Cloud | 2025.0.0 |
| **Service Discovery** | Netflix Eureka | Latest |
| **Language** | Java | 21 |
| **Build Tool** | Maven | 3.x |
| **Container** | Docker | Latest |

### Dependencies

```xml
<dependencies>
    <!-- Eureka Server -->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
    </dependency>
    
    <!-- Spring Boot Actuator -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    
    <!-- Security Libraries -->
    <dependency>
        <groupId>org.apache.httpcomponents</groupId>
        <artifactId>httpclient</artifactId>
        <version>4.5.13</version>
    </dependency>
    
    <dependency>
        <groupId>org.apache.commons</groupId>
        <artifactId>commons-lang3</artifactId>
        <version>3.18.0</version>
    </dependency>
</dependencies>
```

---

## ⚙️ Configuration

### Application Configuration

**File**: `src/main/resources/application.yml`

```yaml
server:
  port: 8761 # Default Eureka port

eureka:
  client:
    register-with-eureka: false # Don't register the server itself
    fetch-registry: false # Don't fetch registry data
    service-url:
      defaultZone: http://localhost:${server.port}/eureka/
  instance:
    hostname: localhost
    
  server:
    # Self-preservation mode (disabled in dev, enabled in prod)
    enable-self-preservation: false
    # Eviction interval (how often to check for expired instances)
    eviction-interval-timer-in-ms: 30000
    # Response cache update interval
    response-cache-update-interval-ms: 30000

spring:
  application:
    name: discovery-service
  cloud:
    config:
      enabled: false # Disable config server for standalone mode
      import-check:
        enabled: false
    gateway:
      discovery:
        locator:
          enabled: true # Enable service discovery for gateway
          lower-case-service-id: true

# Management endpoints
management:
  endpoints:
    web:
      exposure:
        include: '*' # Expose all management endpoints
  endpoint:
    health:
      show-details: always # Always show health details
  metrics:
    export:
      prometheus:
        enabled: true

# Logging
logging:
  level:
    com.netflix.eureka: INFO
    com.netflix.discovery: INFO
```

### Environment-Specific Configuration

**Development** (`config/discovery-service-dev.yml`):
```yaml
eureka:
  server:
    enable-self-preservation: false # Disable for faster instance removal
  instance:
    hostname: localhost
```

**Production** (`config/discovery-service-prod.yml`):
```yaml
eureka:
  server:
    enable-self-preservation: true # Enable for network resilience
    eviction-interval-timer-in-ms: 60000
  instance:
    hostname: eureka-server # Use DNS name in production
    prefer-ip-address: false
```

### Client Configuration (For Other Services)

Services that register with Eureka should include:

```yaml
eureka:
  client:
    service-url:
      defaultZone: http://localhost:8761/eureka/
    register-with-eureka: true
    fetch-registry: true
  instance:
    prefer-ip-address: true
    lease-renewal-interval-in-seconds: 30 # Heartbeat interval
    lease-expiration-duration-in-seconds: 90 # Time before eviction
```

---

## 🚀 Getting Started

### Prerequisites

- Java 21 or higher
- Maven 3.8+
- Docker (optional)

### Option 1: Run with Maven

```bash
# Navigate to discovery service directory
cd apps/discovery-service

# Build the service
mvn clean install

# Run the service
mvn spring-boot:run
```

### Option 2: Run with Java

```bash
# Build the JAR
mvn clean package -DskipTests

# Run the JAR
java -jar target/discovery-service-0.0.1-SNAPSHOT.jar
```

### Option 3: Run with Docker

```bash
# Build Docker image
docker build -t yaniq/discovery-service:latest .

# Run container
docker run -d \
  --name discovery-service \
  -p 8761:8761 \
  yaniq/discovery-service:latest
```

### Option 4: Docker Compose

```bash
# Start with all infrastructure
docker-compose up -d discovery-service
```

### Verification

Once started, verify the service is running:

1. **Dashboard**: http://localhost:8761
2. **Health Check**: http://localhost:8761/actuator/health
3. **Service Registry**: http://localhost:8761/eureka/apps

Expected response:
```json
{
  "status": "UP",
  "components": {
    "diskSpace": {"status": "UP"},
    "ping": {"status": "UP"}
  }
}
```

---

## 📡 API Reference

### REST Endpoints

#### 1. Dashboard UI
```
GET http://localhost:8761/
```
Web interface showing all registered services and their instances.

#### 2. Get All Registered Services
```
GET http://localhost:8761/eureka/apps
Accept: application/json
```

**Response Example**:
```json
{
  "applications": {
    "application": [
      {
        "name": "AUTH-SERVICE",
        "instance": [
          {
            "instanceId": "localhost:auth-service:8081",
            "hostName": "localhost",
            "app": "AUTH-SERVICE",
            "ipAddr": "192.168.1.100",
            "status": "UP",
            "port": {"$": 8081, "@enabled": "true"},
            "healthCheckUrl": "http://localhost:8081/actuator/health",
            "statusPageUrl": "http://localhost:8081/actuator/info",
            "homePageUrl": "http://localhost:8081/",
            "metadata": {
              "management.port": "8081"
            }
          }
        ]
      }
    ]
  }
}
```

#### 3. Get Specific Service
```
GET http://localhost:8761/eureka/apps/{SERVICE-NAME}
Accept: application/json
```

#### 4. Get Service Instance
```
GET http://localhost:8761/eureka/apps/{SERVICE-NAME}/{INSTANCE-ID}
Accept: application/json
```

#### 5. Register Service (Client Side)
```
POST http://localhost:8761/eureka/apps/{SERVICE-NAME}
Content-Type: application/json
```

#### 6. Send Heartbeat (Client Side)
```
PUT http://localhost:8761/eureka/apps/{SERVICE-NAME}/{INSTANCE-ID}
```

#### 7. Deregister Service (Client Side)
```
DELETE http://localhost:8761/eureka/apps/{SERVICE-NAME}/{INSTANCE-ID}
```

---

## 📊 Monitoring & Health

### Health Check Endpoints

#### Service Health
```bash
curl http://localhost:8761/actuator/health
```

**Response**:
```json
{
  "status": "UP",
  "components": {
    "discoveryComposite": {
      "status": "UP",
      "components": {
        "eureka": {
          "status": "UP",
          "details": {
            "applications": {
              "AUTH-SERVICE": 1,
              "USER-SERVICE": 1,
              "GATEWAY-SERVICE": 1
            }
          }
        }
      }
    },
    "diskSpace": {
      "status": "UP",
      "details": {
        "total": 500000000000,
        "free": 250000000000,
        "threshold": 10485760
      }
    }
  }
}
```

#### Service Info
```bash
curl http://localhost:8761/actuator/info
```

#### Service Metrics
```bash
curl http://localhost:8761/actuator/metrics
```

### Key Metrics to Monitor

| Metric | Description | Threshold |
|--------|-------------|-----------|
| **Registered Instances** | Total services registered | > 0 |
| **Heartbeat Count** | Successful heartbeats/min | > 0 |
| **Eviction Count** | Instances evicted | Low |
| **Response Cache Hit Rate** | Cache efficiency | > 90% |
| **CPU Usage** | Server CPU utilization | < 80% |
| **Memory Usage** | JVM memory usage | < 80% |

### Prometheus Metrics

```bash
curl http://localhost:8761/actuator/prometheus
```

Key metrics:
- `eureka_server_registry_count` - Number of registered instances
- `eureka_server_renewal_threshold` - Expected renewal threshold
- `eureka_server_num_of_apps` - Number of applications registered

---

## 🔒 Security Considerations

### Production Security Checklist

- [ ] **Enable Authentication** - Secure Eureka endpoints
- [ ] **Use HTTPS** - Enable SSL/TLS encryption
- [ ] **Network Isolation** - Deploy in private network
- [ ] **Firewall Rules** - Restrict access to trusted services
- [ ] **Actuator Security** - Secure management endpoints
- [ ] **Disable Dashboard** - In production (optional)

### Enabling Basic Authentication

```yaml
spring:
  security:
    user:
      name: admin
      password: ${EUREKA_PASSWORD:changeme}
```

Client configuration with authentication:
```yaml
eureka:
  client:
    service-url:
      defaultZone: http://admin:${EUREKA_PASSWORD}@localhost:8761/eureka/
```

---

## 🏢 High Availability Setup

### Multi-Instance Cluster

For production, deploy multiple Eureka instances for high availability.

#### Instance 1 Configuration
```yaml
server:
  port: 8761

eureka:
  instance:
    hostname: eureka-1
  client:
    register-with-eureka: true
    fetch-registry: true
    service-url:
      defaultZone: http://eureka-2:8762/eureka/,http://eureka-3:8763/eureka/
```

#### Instance 2 Configuration
```yaml
server:
  port: 8762

eureka:
  instance:
    hostname: eureka-2
  client:
    register-with-eureka: true
    fetch-registry: true
    service-url:
      defaultZone: http://eureka-1:8761/eureka/,http://eureka-3:8763/eureka/
```

#### Instance 3 Configuration
```yaml
server:
  port: 8763

eureka:
  instance:
    hostname: eureka-3
  client:
    register-with-eureka: true
    fetch-registry: true
    service-url:
      defaultZone: http://eureka-1:8761/eureka/,http://eureka-2:8762/eureka/
```

### Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: eureka-server
spec:
  serviceName: eureka
  replicas: 3
  selector:
    matchLabels:
      app: eureka-server
  template:
    metadata:
      labels:
        app: eureka-server
    spec:
      containers:
      - name: eureka-server
        image: yaniq/discovery-service:latest
        ports:
        - containerPort: 8761
        env:
        - name: EUREKA_INSTANCE_HOSTNAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
```

---

## 🔧 Troubleshooting

### Common Issues

#### 1. Service Not Registering

**Problem**: Service doesn't appear in Eureka dashboard

**Solutions**:
- ✅ Check if service has correct Eureka client dependency
- ✅ Verify `eureka.client.service-url.defaultZone` configuration
- ✅ Ensure network connectivity to Eureka server
- ✅ Check application logs for registration errors
- ✅ Verify service name is configured correctly

#### 2. Instances Showing as DOWN

**Problem**: Registered instances marked as DOWN

**Solutions**:
- ✅ Check heartbeat configuration (lease-renewal-interval)
- ✅ Verify network connectivity
- ✅ Check if service actuator health endpoint is accessible
- ✅ Review eviction timeout settings
- ✅ Disable self-preservation mode (dev only)

#### 3. Delayed Instance Removal

**Problem**: Dead instances remain in registry

**Solutions**:
- ✅ Adjust `eviction-interval-timer-in-ms` (default: 60s)
- ✅ Check `lease-expiration-duration-in-seconds` (default: 90s)
- ✅ Disable self-preservation mode in development
- ✅ Force refresh cache interval

#### 4. Self-Preservation Mode

**Problem**: "EMERGENCY! EUREKA MAY BE INCORRECTLY CLAIMING INSTANCES ARE UP WHEN THEY'RE NOT"

**Explanation**: Eureka enters self-preservation when heartbeat renewals drop below threshold

**Solutions**:
- ✅ Development: Disable with `eureka.server.enable-self-preservation: false`
- ✅ Production: This is normal during network issues - wait for recovery
- ✅ Check network connectivity to services
- ✅ Review heartbeat thresholds

#### 5. High Memory Usage

**Problem**: Eureka server consuming excessive memory

**Solutions**:
- ✅ Increase JVM heap size: `-Xmx2g -Xms2g`
- ✅ Reduce response cache size
- ✅ Limit registry size threshold
- ✅ Enable response cache compression

### Debug Logging

Enable detailed logging for troubleshooting:

```yaml
logging:
  level:
    com.netflix.eureka: DEBUG
    com.netflix.discovery: DEBUG
```

---

## 🚀 Production Deployment

### Docker Production Image

**Dockerfile**:
```dockerfile
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/discovery-service-*.jar app.jar
EXPOSE 8761

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:8761/actuator/health || exit 1

ENTRYPOINT ["java", "-XX:+UseG1GC", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SERVER_PORT` | Server port | 8761 |
| `EUREKA_INSTANCE_HOSTNAME` | Instance hostname | localhost |
| `EUREKA_SERVER_ENABLE_SELF_PRESERVATION` | Self-preservation mode | true |
| `JAVA_OPTS` | JVM options | - |

### Resource Requirements

**Minimum**:
- CPU: 0.5 cores
- Memory: 512 MB
- Storage: 1 GB

**Recommended**:
- CPU: 2 cores
- Memory: 2 GB
- Storage: 5 GB

### Monitoring Checklist

- [ ] Prometheus metrics scraping configured
- [ ] Grafana dashboard deployed
- [ ] Alerting rules configured
- [ ] Log aggregation enabled (ELK/Loki)
- [ ] Health check probes configured
- [ ] Backup strategy for configuration

---

## 📈 Performance Tuning

### JVM Tuning

```bash
java -jar \
  -Xmx2g \
  -Xms2g \
  -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  -XX:+UseStringDeduplication \
  discovery-service.jar
```

### Cache Optimization

```yaml
eureka:
  server:
    response-cache-update-interval-ms: 30000 # Update cache every 30s
    response-cache-auto-expiration-in-seconds: 180 # Cache expiry
```

### Network Optimization

```yaml
eureka:
  instance:
    lease-renewal-interval-in-seconds: 30 # Heartbeat frequency
    lease-expiration-duration-in-seconds: 90 # Eviction timeout
```

---

## 📚 Additional Resources

- 📖 [Spring Cloud Netflix Eureka Documentation](https://spring.io/projects/spring-cloud-netflix)
- 🎓 [Netflix Eureka Wiki](https://github.com/Netflix/eureka/wiki)
- 🔧 [Spring Boot Actuator Guide](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- 📊 [Monitoring Microservices](https://microservices.io/patterns/observability/application-metrics.html)

---

## 🆘 Support

For issues and questions:
- 🐛 [Report Issues](https://github.com/yaniq/yaniq-monorepo/issues)
- 💬 [GitHub Discussions](https://github.com/yaniq/yaniq-monorepo/discussions)
- 📧 Email: danukajihansanath0408@gmail.com

---

<div align="center">

**Discovery Service** | **Status**: ✅ Production Ready

[⬆ Back to Top](#-discovery-service-documentation) | [📖 Main Documentation](../README.md)

</div>

