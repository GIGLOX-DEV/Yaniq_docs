---
layout: default
title: Configuration
nav_order: 7
description: "Configuration management for YaniQ services"
permalink: /CONFIGURATION
---

# ⚙️ Configuration Guide

<div align="center">

![Configuration](https://img.shields.io/badge/Guide-Configuration-blue?style=for-the-badge)
![Spring Cloud Config](https://img.shields.io/badge/Spring%20Cloud-Config-green?style=for-the-badge)

**Comprehensive Configuration Management for YaniQ Platform**

[Overview](#-overview) •
[Configuration Files](#-configuration-files) •
[Environment Variables](#-environment-variables) •
[Profiles](#-profiles) •
[Best Practices](#-best-practices)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Configuration Structure](#-configuration-structure)
- [Configuration Files](#-configuration-files)
- [Environment Variables](#-environment-variables)
- [Spring Profiles](#-spring-profiles)
- [Service-Specific Configuration](#-service-specific-configuration)
- [Database Configuration](#-database-configuration)
- [Cache Configuration](#-cache-configuration)
- [Messaging Configuration](#-messaging-configuration)
- [Security Configuration](#-security-configuration)
- [Monitoring Configuration](#-monitoring-configuration)
- [Best Practices](#-best-practices)

---

## 🌟 Overview

YaniQ uses **Spring Cloud Config** pattern with externalized configuration files stored in the `/config` directory. This approach provides:

- ✅ **Centralized Configuration** - Single source of truth
- ✅ **Environment-Specific** - Different configs for dev/prod
- ✅ **Version Control** - Configuration tracked in Git
- ✅ **Hot Reload** - Update configs without restart (planned)
- ✅ **Security** - Sensitive data encryption support

---

## 📁 Configuration Structure

```
config/
├── application.yml              # Global default configuration
├── application-dev.yml          # Development overrides
├── application-prod.yml         # Production overrides
├── application-cache.yml        # Cache configuration
├── application-cache-dev.yml
├── application-cache-prod.yml
├── application-message.yml      # Messaging configuration
├── application-message-dev.yml
├── application-message-prod.yml
├── jwt-config.yml               # JWT settings
├── role-seeding.yml             # Initial role data
├── discovery-service.yml        # Eureka configuration
├── discovery-service-dev.yml
├── discovery-service-prod.yml
├── gateway-service.yml          # Gateway configuration
├── gateway-service-dev.yml
├── gateway-service-prod.yml
├── auth-service.yml             # Auth service configuration
├── auth-service-dev.yml
├── auth-service-prod.yml
├── user-service.yml
├── product-service.yml
├── order-service.yml
├── payment-service.yml
├── cart-service.yml
├── inventory-service.yml
├── notification-service.yml
└── ... (other service configs)
```

---

## 📄 Configuration Files

### 1. Global Application Configuration

**File**: `config/application.yml`

```yaml
# Global settings applied to all services
spring:
  application:
    name: ${SERVICE_NAME:unknown-service}
  
  # JPA defaults
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: false
    properties:
      hibernate:
        format_sql: true
        dialect: org.hibernate.dialect.PostgreSQLDialect
  
  # Jackson defaults
  jackson:
    serialization:
      write-dates-as-timestamps: false
    default-property-inclusion: non_null

# Eureka client defaults
eureka:
  client:
    service-url:
      defaultZone: ${EUREKA_SERVER_URL:http://localhost:8761/eureka/}
    register-with-eureka: true
    fetch-registry: true
  instance:
    prefer-ip-address: true
    lease-renewal-interval-in-seconds: 30
    lease-expiration-duration-in-seconds: 90

# Actuator defaults
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: when-authorized
  metrics:
    export:
      prometheus:
        enabled: true

# Logging defaults
logging:
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n"
    file: "%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n"
  level:
    root: INFO
    com.yaniq: DEBUG
```

### 2. Development Profile

**File**: `config/application-dev.yml`

```yaml
# Development environment settings
spring:
  jpa:
    hibernate:
      ddl-auto: update  # Auto-create/update schema
    show-sql: true      # Show SQL queries
  
  # H2 Console (optional)
  h2:
    console:
      enabled: false

# Relaxed Eureka settings for dev
eureka:
  instance:
    lease-renewal-interval-in-seconds: 5
    lease-expiration-duration-in-seconds: 10

# Verbose logging for development
logging:
  level:
    root: INFO
    com.yaniq: DEBUG
    org.springframework.web: DEBUG
    org.hibernate.SQL: DEBUG
    org.hibernate.type.descriptor.sql.BasicBinder: TRACE

# Disable security for easier testing (optional)
management:
  endpoints:
    web:
      exposure:
        include: '*'
  endpoint:
    health:
      show-details: always
```

### 3. Production Profile

**File**: `config/application-prod.yml`

```yaml
# Production environment settings
spring:
  jpa:
    hibernate:
      ddl-auto: validate  # Never auto-update schema
    show-sql: false       # Disable SQL logging
  
  # Connection pool optimization
  datasource:
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000

# Production Eureka settings
eureka:
  instance:
    prefer-ip-address: false
    hostname: ${HOSTNAME}
    lease-renewal-interval-in-seconds: 30
    lease-expiration-duration-in-seconds: 90

# Production logging
logging:
  level:
    root: WARN
    com.yaniq: INFO
  file:
    name: /var/log/yaniq/${spring.application.name}.log
    max-size: 100MB
    max-history: 30

# Secure actuator endpoints
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: never
```

---

## 🔐 Environment Variables

### Required Environment Variables

```bash
# Service Identity
SERVICE_NAME=discovery-service
SERVER_PORT=8761

# Service Discovery
EUREKA_SERVER_URL=http://localhost:8761/eureka/

# Database
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=yaniq_db
POSTGRES_USER=yaniq
POSTGRES_PASSWORD=changeme
DATABASE_URL=jdbc:postgresql://${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DATABASE=0

# Kafka
KAFKA_BOOTSTRAP_SERVERS=localhost:9092
KAFKA_GROUP_ID=${SERVICE_NAME}-group

# Security
JWT_SECRET=your-256-bit-secret-key-change-in-production
JWT_EXPIRATION=86400000  # 24 hours in milliseconds
JWT_REFRESH_EXPIRATION=604800000  # 7 days

# Application
SPRING_PROFILES_ACTIVE=dev
LOG_LEVEL=INFO

# Optional: External Services
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
```

### Environment Variable Priority

1. **System Environment Variables** (highest priority)
2. **Command-line arguments** (`--property=value`)
3. **application-{profile}.yml** (profile-specific)
4. **application.yml** (default)
5. **Hard-coded defaults** (lowest priority)

---

## 🎭 Spring Profiles

### Available Profiles

| Profile | Purpose | Use Case |
|---------|---------|----------|
| `dev` | Development | Local development |
| `prod` | Production | Production deployment |
| `test` | Testing | Integration/E2E tests |
| `docker` | Docker | Docker Compose deployment |
| `k8s` | Kubernetes | Kubernetes deployment |

### Activating Profiles

#### Method 1: Environment Variable
```bash
export SPRING_PROFILES_ACTIVE=dev
mvn spring-boot:run
```

#### Method 2: Command Line
```bash
mvn spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=dev
```

#### Method 3: Application Properties
```yaml
spring:
  profiles:
    active: dev
```

#### Method 4: Docker
```bash
docker run -e SPRING_PROFILES_ACTIVE=prod yaniq/service:latest
```

#### Method 5: Kubernetes ConfigMap
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: service-config
data:
  SPRING_PROFILES_ACTIVE: "prod"
```

---

## 🔧 Service-Specific Configuration

### Discovery Service Configuration

**File**: `config/discovery-service.yml`

```yaml
server:
  port: 8761

spring:
  application:
    name: discovery-service

eureka:
  client:
    register-with-eureka: false
    fetch-registry: false
    service-url:
      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
  instance:
    hostname: localhost
  server:
    enable-self-preservation: true
    eviction-interval-timer-in-ms: 60000
    response-cache-update-interval-ms: 30000

management:
  endpoints:
    web:
      exposure:
        include: '*'
  endpoint:
    health:
      show-details: always
```

### Gateway Service Configuration

**File**: `config/gateway-service.yml`

```yaml
server:
  port: 8080

spring:
  application:
    name: gateway-service
  cloud:
    gateway:
      discovery:
        locator:
          enabled: true
          lower-case-service-id: true
      routes:
        # Auth Service Routes
        - id: auth-service
          uri: lb://auth-service
          predicates:
            - Path=/api/auth/**
          filters:
            - StripPrefix=1
        
        # User Service Routes
        - id: user-service
          uri: lb://user-service
          predicates:
            - Path=/api/users/**
          filters:
            - StripPrefix=1
        
        # Product Service Routes
        - id: product-service
          uri: lb://product-service
          predicates:
            - Path=/api/products/**
          filters:
            - StripPrefix=1
      
      # Global CORS Configuration
      globalcors:
        cors-configurations:
          '[/**]':
            allowed-origins: "*"
            allowed-methods:
              - GET
              - POST
              - PUT
              - DELETE
              - PATCH
            allowed-headers: "*"
            allow-credentials: false

# Rate Limiting (Redis-based)
spring.redis:
  host: ${REDIS_HOST:localhost}
  port: ${REDIS_PORT:6379}
```

### Auth Service Configuration

**File**: `config/auth-service.yml`

```yaml
server:
  port: 8081

spring:
  application:
    name: auth-service
  
  datasource:
    url: ${DATABASE_URL:jdbc:postgresql://localhost:5432/auth_db}
    username: ${POSTGRES_USER:yaniq}
    password: ${POSTGRES_PASSWORD:changeme}
    driver-class-name: org.postgresql.Driver
  
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: false

# JWT Configuration
jwt:
  secret: ${JWT_SECRET}
  expiration: ${JWT_EXPIRATION:86400000}
  refresh-expiration: ${JWT_REFRESH_EXPIRATION:604800000}
  header: Authorization
  prefix: Bearer 

# Security
security:
  password:
    encoder: bcrypt
    strength: 10
```

---

## 🗄️ Database Configuration

### PostgreSQL Configuration

```yaml
spring:
  datasource:
    url: jdbc:postgresql://${POSTGRES_HOST:localhost}:${POSTGRES_PORT:5432}/${POSTGRES_DB:yaniq_db}
    username: ${POSTGRES_USER:yaniq}
    password: ${POSTGRES_PASSWORD:changeme}
    driver-class-name: org.postgresql.Driver
    
    # HikariCP Connection Pool
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
      pool-name: ${spring.application.name}-pool
  
  jpa:
    database-platform: org.hibernate.dialect.PostgreSQLDialect
    hibernate:
      ddl-auto: validate
    properties:
      hibernate:
        jdbc:
          batch_size: 20
        order_inserts: true
        order_updates: true
```

### Database per Service

Each service has its own database:

```yaml
# Auth Service → auth_db
# User Service → user_db
# Product Service → product_db
# Order Service → order_db
# Payment Service → payment_db
# Inventory Service → inventory_db
```

---

## 💾 Cache Configuration

**File**: `config/application-cache.yml`

```yaml
spring:
  cache:
    type: redis
  
  redis:
    host: ${REDIS_HOST:localhost}
    port: ${REDIS_PORT:6379}
    password: ${REDIS_PASSWORD:}
    database: ${REDIS_DATABASE:0}
    timeout: 2000ms
    
    lettuce:
      pool:
        max-active: 8
        max-idle: 8
        min-idle: 0
        max-wait: -1ms
    
    # Time-to-live for cache entries
    time-to-live: 600000  # 10 minutes

# Cache names and TTLs
cache:
  names:
    products: 3600000      # 1 hour
    categories: 7200000    # 2 hours
    users: 1800000         # 30 minutes
    cart: 86400000         # 24 hours
```

---

## 📨 Messaging Configuration

**File**: `config/application-message.yml`

```yaml
spring:
  kafka:
    bootstrap-servers: ${KAFKA_BOOTSTRAP_SERVERS:localhost:9092}
    
    # Producer Configuration
    producer:
      key-serializer: org.apache.kafka.common.serialization.StringSerializer
      value-serializer: org.springframework.kafka.support.serializer.JsonSerializer
      acks: all
      retries: 3
      properties:
        enable.idempotence: true
    
    # Consumer Configuration
    consumer:
      group-id: ${KAFKA_GROUP_ID:${spring.application.name}-group}
      key-deserializer: org.apache.kafka.common.serialization.StringDeserializer
      value-deserializer: org.springframework.kafka.support.serializer.JsonDeserializer
      auto-offset-reset: earliest
      enable-auto-commit: false
      properties:
        spring.json.trusted.packages: "*"

# Topic Configuration
kafka:
  topics:
    order-events: order-events
    payment-events: payment-events
    inventory-events: inventory-events
    notification-events: notification-events
```

---

## 🔒 Security Configuration

**File**: `config/jwt-config.yml`

```yaml
jwt:
  secret: ${JWT_SECRET}
  expiration: 86400000  # 24 hours
  refresh-expiration: 604800000  # 7 days
  header: Authorization
  prefix: "Bearer "
  issuer: yaniq-platform

security:
  # CORS Configuration
  cors:
    allowed-origins:
      - http://localhost:3000
      - http://localhost:4200
    allowed-methods:
      - GET
      - POST
      - PUT
      - DELETE
      - PATCH
      - OPTIONS
    allowed-headers:
      - Authorization
      - Content-Type
      - X-Requested-With
    exposed-headers:
      - Authorization
    allow-credentials: true
    max-age: 3600
  
  # Password Policy
  password:
    min-length: 8
    require-uppercase: true
    require-lowercase: true
    require-digit: true
    require-special: true
```

---

## 📊 Monitoring Configuration

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus,env,loggers
      base-path: /actuator
  
  endpoint:
    health:
      show-details: when-authorized
      probes:
        enabled: true
    
    metrics:
      enabled: true
  
  metrics:
    export:
      prometheus:
        enabled: true
    tags:
      application: ${spring.application.name}
      environment: ${spring.profiles.active}
  
  health:
    circuitbreakers:
      enabled: true
    ratelimiters:
      enabled: true

# Prometheus metrics
spring:
  metrics:
    export:
      prometheus:
        descriptions: true
```

---

## ✅ Best Practices

### 1. Never Commit Secrets

```bash
# Use .env files (gitignored)
echo "JWT_SECRET=your-secret-key" >> .env

# Or environment variables
export JWT_SECRET=your-secret-key

# Or secret management tools
# - Kubernetes Secrets
# - HashiCorp Vault
# - AWS Secrets Manager
```

### 2. Use Profile-Specific Configs

```yaml
# application.yml (defaults)
logging:
  level:
    root: INFO

# application-dev.yml (development overrides)
logging:
  level:
    root: DEBUG
```

### 3. Externalize Configuration

```yaml
# Don't hardcode URLs
database:
  url: jdbc:postgresql://localhost:5432/db  # ❌ Bad

# Use environment variables
database:
  url: ${DATABASE_URL}  # ✅ Good
```

### 4. Document Configuration

```yaml
# Add comments to complex configuration
cache:
  # Product cache TTL (1 hour in milliseconds)
  # Adjust based on product update frequency
  product-ttl: 3600000
```

### 5. Validate Configuration

```java
@Configuration
@ConfigurationProperties(prefix = "jwt")
@Validated
public class JwtProperties {
    
    @NotBlank(message = "JWT secret must not be blank")
    private String secret;
    
    @Min(value = 60000, message = "Expiration must be at least 1 minute")
    private long expiration;
    
    // getters and setters
}
```

---

## 🔄 Configuration Reload

### Spring Cloud Config Server (Planned)

```yaml
spring:
  cloud:
    config:
      server:
        git:
          uri: https://github.com/yaniq/config-repo
          default-label: main
          search-paths: config
```

### Refresh Configuration

```bash
# Trigger configuration refresh
curl -X POST http://localhost:8081/actuator/refresh
```

---

## 📚 Additional Resources

- 📖 [Spring Boot Configuration](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config)
- 🔧 [Spring Cloud Config](https://spring.io/projects/spring-cloud-config)
- 🔐 [Externalized Configuration Best Practices](https://12factor.net/config)

---

<div align="center">

**Configuration Guide** | **YaniQ E-Commerce Platform**

[⬆ Back to Top](#️-configuration-guide) | [📖 Main Documentation](./README.md)

</div>
