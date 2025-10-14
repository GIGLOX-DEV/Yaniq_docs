# 🔧 Troubleshooting Guide

<div align="center">

![Troubleshooting](https://img.shields.io/badge/Guide-Troubleshooting-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)

**Common Issues and Solutions for YaniQ Platform**

[Service Issues](#-service-issues) •
[Infrastructure](#-infrastructure-issues) •
[Configuration](#-configuration-issues) •
[Performance](#-performance-issues) •
[Security](#-security-issues)

</div>

---

## 📋 Table of Contents

- [Service Issues](#-service-issues)
- [Infrastructure Issues](#-infrastructure-issues)
- [Configuration Issues](#-configuration-issues)
- [Database Issues](#-database-issues)
- [Cache Issues](#-cache-issues)
- [Messaging Issues](#-messaging-issues)
- [Performance Issues](#-performance-issues)
- [Security Issues](#-security-issues)
- [Docker Issues](#-docker-issues)
- [Kubernetes Issues](#-kubernetes-issues)

---

## 🚨 Service Issues

### Discovery Service Not Starting

**Symptoms**:
- Service fails to start
- Port 8761 already in use
- Connection refused errors

**Solutions**:

```bash
# Check if port is in use
lsof -i :8761  # macOS/Linux
netstat -ano | findstr :8761  # Windows

# Kill process using port
kill -9 <PID>  # macOS/Linux
taskkill /PID <PID> /F  # Windows

# Check logs
cd apps/discovery-service
mvn spring-boot:run

# Verify application.yml
cat src/main/resources/application.yml
```

### Services Not Registering with Eureka

**Symptoms**:
- Service running but not visible in Eureka dashboard
- "Eureka client not available" errors
- Gateway returns 503 errors

**Diagnosis**:

```bash
# Check Eureka dashboard
open http://localhost:8761

# Check service logs
cd apps/auth-service
mvn spring-boot:run | grep -i eureka

# Test Eureka endpoint
curl http://localhost:8761/eureka/apps
```

**Solutions**:

1. **Verify Eureka Configuration**:
```yaml
# Check application.yml
eureka:
  client:
    service-url:
      defaultZone: http://localhost:8761/eureka/
    register-with-eureka: true
    fetch-registry: true
```

2. **Wait for Registration**:
```bash
# Services take 30-60 seconds to register
# Check service logs for:
# "DiscoveryClient... registering service"
```

3. **Check Network Connectivity**:
```bash
# From service container/pod
curl http://discovery-service:8761/eureka/apps

# If fails, check DNS/network configuration
```

4. **Disable Self-Preservation (Dev Only)**:
```yaml
# config/discovery-service-dev.yml
eureka:
  server:
    enable-self-preservation: false
```

### Gateway Returns 503 Service Unavailable

**Symptoms**:
- All requests through gateway fail
- "No instances available" errors

**Solutions**:

1. **Check Service Discovery**:
```bash
# Verify services registered
curl http://localhost:8761/eureka/apps

# Check gateway logs
docker-compose logs gateway-service
```

2. **Verify Gateway Routes**:
```bash
# Check configured routes
curl http://localhost:8080/actuator/gateway/routes

# Test direct service access
curl http://localhost:8081/actuator/health
```

3. **Check Load Balancer**:
```yaml
# Verify load balancer configuration
spring:
  cloud:
    loadbalancer:
      ribbon:
        enabled: false
```

### Authentication Failures

**Symptoms**:
- Login returns 401 Unauthorized
- JWT token validation fails
- "Invalid token" errors

**Solutions**:

1. **Check JWT Secret**:
```bash
# Verify JWT_SECRET is set
echo $JWT_SECRET

# Check application configuration
curl http://localhost:8081/actuator/env | grep jwt
```

2. **Verify Token Format**:
```bash
# Test login endpoint
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# Decode JWT (use jwt.io or)
echo "YOUR_TOKEN" | cut -d'.' -f2 | base64 -d
```

3. **Check Database Connection**:
```bash
# Verify auth database
docker exec -it postgres psql -U yaniq -d auth_db -c "\dt"
```

---

## 🏗️ Infrastructure Issues

### PostgreSQL Connection Errors

**Symptoms**:
- "Connection refused" errors
- "Database does not exist" errors
- Authentication failures

**Diagnosis**:

```bash
# Check if PostgreSQL is running
docker ps | grep postgres

# Check PostgreSQL logs
docker logs postgres

# Test connection
docker exec -it postgres psql -U yaniq -l
```

**Solutions**:

1. **Start PostgreSQL**:
```bash
docker-compose up -d postgres

# Wait for startup
docker-compose logs -f postgres
# Look for: "database system is ready to accept connections"
```

2. **Create Missing Databases**:
```bash
# Connect to PostgreSQL
docker exec -it postgres psql -U yaniq

# Create database
CREATE DATABASE auth_db;
CREATE DATABASE user_db;
CREATE DATABASE product_db;

# Verify
\l
```

3. **Fix Connection String**:
```yaml
# Correct format
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/auth_db
    username: yaniq
    password: changeme
```

4. **Reset PostgreSQL**:
```bash
# Stop and remove
docker-compose down -v

# Start fresh
docker-compose up -d postgres
```

### Redis Connection Issues

**Symptoms**:
- Cache operations fail
- "Connection refused" to Redis
- Rate limiting not working

**Solutions**:

```bash
# Check Redis status
docker ps | grep redis

# Test Redis connection
docker exec -it redis redis-cli ping
# Expected: PONG

# Check Redis logs
docker logs redis

# Restart Redis
docker-compose restart redis

# Clear Redis data
docker exec -it redis redis-cli FLUSHALL
```

### Kafka Connection Problems

**Symptoms**:
- Events not being published/consumed
- "Broker not available" errors
- Consumer lag increasing

**Solutions**:

```bash
# Check Kafka status
docker ps | grep kafka

# List topics
docker exec -it kafka kafka-topics.sh \
  --list --bootstrap-server localhost:9092

# Check consumer groups
docker exec -it kafka kafka-consumer-groups.sh \
  --bootstrap-server localhost:9092 --list

# Test producer
docker exec -it kafka kafka-console-producer.sh \
  --bootstrap-server localhost:9092 --topic test-topic

# Test consumer
docker exec -it kafka kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --topic test-topic --from-beginning

# Restart Kafka
docker-compose restart kafka zookeeper
```

---

## ⚙️ Configuration Issues

### Environment Variables Not Loading

**Symptoms**:
- Default values used instead of custom
- "Property not found" errors

**Solutions**:

1. **Check .env File**:
```bash
# Verify .env exists
ls -la .env

# Check contents
cat .env | grep JWT_SECRET

# Load environment
source .env
echo $JWT_SECRET
```

2. **Verify Profile Active**:
```bash
# Check active profile
curl http://localhost:8081/actuator/env | grep "spring.profiles.active"

# Set profile
export SPRING_PROFILES_ACTIVE=dev
mvn spring-boot:run
```

3. **Docker Compose Environment**:
```yaml
# docker-compose.yml
services:
  auth-service:
    environment:
      - SPRING_PROFILES_ACTIVE=prod
      - JWT_SECRET=${JWT_SECRET}
    env_file:
      - .env
```

### Configuration Not Taking Effect

**Solutions**:

```bash
# Clear Maven cache
mvn clean install

# Rebuild Docker images
docker-compose build --no-cache

# Restart services
docker-compose restart

# Force configuration refresh
curl -X POST http://localhost:8081/actuator/refresh
```

---

## 🗄️ Database Issues

### Schema Mismatch Errors

**Symptoms**:
- "Column not found" errors
- "Table doesn't exist" errors
- Hibernate validation fails

**Solutions**:

1. **Update Schema**:
```bash
# Development: Auto-update
# application-dev.yml
spring:
  jpa:
    hibernate:
      ddl-auto: update
```

2. **Run Migrations**:
```bash
# Using Flyway/Liquibase
mvn flyway:migrate

# Or manually
docker exec -it postgres psql -U yaniq -d auth_db -f /migrations/V1__init.sql
```

3. **Reset Database**:
```bash
# Drop and recreate
docker exec -it postgres psql -U yaniq -c "DROP DATABASE auth_db;"
docker exec -it postgres psql -U yaniq -c "CREATE DATABASE auth_db;"

# Restart service to recreate schema
docker-compose restart auth-service
```

### Connection Pool Exhausted

**Symptoms**:
- "Unable to acquire JDBC connection" errors
- Slow query performance
- Timeouts

**Solutions**:

```yaml
# Increase pool size
spring:
  datasource:
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000
      idle-timeout: 600000
```

```bash
# Check active connections
docker exec -it postgres psql -U yaniq -c \
  "SELECT count(*) FROM pg_stat_activity;"

# Kill idle connections
docker exec -it postgres psql -U yaniq -c \
  "SELECT pg_terminate_backend(pid) FROM pg_stat_activity 
   WHERE state = 'idle' AND state_change < NOW() - INTERVAL '10 minutes';"
```

---

## 💾 Cache Issues

### Cache Not Working

**Symptoms**:
- Slow response times
- Database queries on every request
- Redis shows no data

**Solutions**:

```bash
# Check Redis connection
docker exec -it redis redis-cli

# In Redis CLI:
PING
KEYS *
GET "cache::products::1"

# Monitor cache activity
MONITOR

# Check service cache config
curl http://localhost:8083/actuator/metrics/cache.gets
```

```java
// Verify cache annotations
@Cacheable(value = "products", key = "#id")
public Product getProduct(Long id) {
    return productRepository.findById(id)
        .orElseThrow();
}
```

### Cache Inconsistency

**Solutions**:

```bash
# Clear all caches
docker exec -it redis redis-cli FLUSHALL

# Clear specific cache
docker exec -it redis redis-cli DEL "cache::products::*"

# Check TTL
docker exec -it redis redis-cli TTL "cache::products::1"
```

---

## 📨 Messaging Issues

### Events Not Being Consumed

**Symptoms**:
- Notification emails not sent
- Inventory not updating after order
- Consumer lag growing

**Solutions**:

```bash
# Check consumer groups
docker exec -it kafka kafka-consumer-groups.sh \
  --bootstrap-server localhost:9092 \
  --group notification-service-group \
  --describe

# Check topic messages
docker exec -it kafka kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --topic order-events \
  --from-beginning

# Reset consumer offset
docker exec -it kafka kafka-consumer-groups.sh \
  --bootstrap-server localhost:9092 \
  --group notification-service-group \
  --reset-offsets --to-earliest \
  --topic order-events --execute
```

---

## 🚀 Performance Issues

### High Memory Usage

**Symptoms**:
- OutOfMemoryError
- Frequent GC pauses
- Slow response times

**Solutions**:

```bash
# Increase JVM heap
export JAVA_OPTS="-Xmx2g -Xms1g"
mvn spring-boot:run

# Docker: Update docker-compose.yml
services:
  auth-service:
    environment:
      JAVA_OPTS: "-Xmx2g -Xms1g -XX:+UseG1GC"

# Monitor memory
curl http://localhost:8081/actuator/metrics/jvm.memory.used
```

### Slow API Responses

**Solutions**:

1. **Enable Caching**:
```yaml
spring:
  cache:
    type: redis
```

2. **Optimize Queries**:
```java
// Add indexes
@Table(name = "products", indexes = {
    @Index(name = "idx_product_name", columnList = "name"),
    @Index(name = "idx_product_category", columnList = "category_id")
})

// Use JOIN FETCH
@Query("SELECT p FROM Product p JOIN FETCH p.category WHERE p.id = :id")
Product findByIdWithCategory(@Param("id") Long id);
```

3. **Check Database Performance**:
```bash
# Enable slow query log
docker exec -it postgres psql -U yaniq -c \
  "ALTER SYSTEM SET log_min_duration_statement = 1000;"
```

---

## 🔒 Security Issues

### CORS Errors

**Symptoms**:
- "CORS policy blocked" in browser
- OPTIONS preflight fails

**Solutions**:

```yaml
# Gateway CORS configuration
spring:
  cloud:
    gateway:
      globalcors:
        cors-configurations:
          '[/**]':
            allowed-origins:
              - "http://localhost:3000"
              - "https://app.yaniq.com"
            allowed-methods:
              - GET
              - POST
              - PUT
              - DELETE
              - OPTIONS
            allowed-headers: "*"
            allow-credentials: true
```

### SSL/TLS Issues

**Solutions**:

```bash
# Generate self-signed certificate (dev only)
keytool -genkeypair -alias yaniq \
  -keyalg RSA -keysize 2048 \
  -storetype PKCS12 -keystore keystore.p12 \
  -validity 3650

# Configure in application.yml
server:
  port: 8443
  ssl:
    key-store: classpath:keystore.p12
    key-store-password: changeit
    key-store-type: PKCS12
    key-alias: yaniq
```

---

## 🐳 Docker Issues

### Container Fails to Start

**Solutions**:

```bash
# Check logs
docker logs <container-name>

# Check resource usage
docker stats

# Remove and recreate
docker-compose down
docker-compose up -d

# Rebuild images
docker-compose build --no-cache
docker-compose up -d
```

### Out of Disk Space

**Solutions**:

```bash
# Check disk usage
docker system df

# Clean up
docker system prune -a --volumes

# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune
```

---

## ☸️ Kubernetes Issues

### Pod CrashLoopBackOff

**Solutions**:

```bash
# Check pod logs
kubectl logs -n yaniq <pod-name>

# Describe pod
kubectl describe pod -n yaniq <pod-name>

# Check events
kubectl get events -n yaniq --sort-by='.lastTimestamp'

# Execute into pod
kubectl exec -it -n yaniq <pod-name> -- /bin/sh
```

### ImagePullBackOff

**Solutions**:

```bash
# Check image exists
docker pull <image-name>

# Verify image pull secret
kubectl get secret -n yaniq

# Create image pull secret
kubectl create secret docker-registry regcred \
  --docker-server=<registry> \
  --docker-username=<username> \
  --docker-password=<password> \
  -n yaniq
```

---

## 🆘 Getting Help

If you can't resolve an issue:

1. **Check Logs**:
```bash
# Service logs
mvn spring-boot:run
docker-compose logs -f service-name
kubectl logs -f pod-name -n yaniq
```

2. **Enable Debug Logging**:
```yaml
logging:
  level:
    root: DEBUG
    com.yaniq: TRACE
```

3. **Report Issue**:
- 🐛 [GitHub Issues](https://github.com/yaniq/yaniq-monorepo/issues)
- 💬 [Discussions](https://github.com/yaniq/yaniq-monorepo/discussions)
- 📧 Email: danukajihansanath0408@gmail.com

---

<div align="center">

**Troubleshooting Guide** | **YaniQ E-Commerce Platform**

[⬆ Back to Top](#-troubleshooting-guide) | [📖 Main Documentation](./README.md)

</div>

