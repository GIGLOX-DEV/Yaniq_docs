---
layout: default
title: Architecture
nav_order: 6
description: "System architecture and design patterns for YaniQ platform"
permalink: /ARCHITECTURE/
---

# 🏗️ System Architecture

<div align="center">

![Architecture](https://img.shields.io/badge/Architecture-Microservices-blue?style=for-the-badge)
![Pattern](https://img.shields.io/badge/Pattern-Event%20Driven-green?style=for-the-badge)
![Cloud Native](https://img.shields.io/badge/Cloud-Native-orange?style=for-the-badge)

**Enterprise-Grade Microservices Architecture for E-Commerce**

[Overview](#-overview) •
[Principles](#-architecture-principles) •
[Components](#-core-components) •
[Patterns](#-design-patterns) •
[Communication](#-communication-patterns)

</div>

---

## 📋 Table of Contents

- [Architecture Overview](#-architecture-overview)
- [Architecture Principles](#-architecture-principles)
- [Core Components](#-core-components)
- [Service Mesh](#-service-mesh-architecture)
- [Design Patterns](#-design-patterns)
- [Communication Patterns](#-communication-patterns)
- [Data Architecture](#-data-architecture)
- [Security Architecture](#-security-architecture)
- [Resilience & Fault Tolerance](#-resilience--fault-tolerance)
- [Observability](#-observability-architecture)
- [Deployment Architecture](#-deployment-architecture)

---

## 🌟 Architecture Overview

YaniQ follows a **Cloud-Native Microservices Architecture** with event-driven communication, leveraging industry-standard patterns and frameworks for building scalable, resilient, and maintainable e-commerce systems.

### High-Level System Architecture

```mermaid
C4Context
    title System Context Diagram - YaniQ E-Commerce Platform

    Person(customer, "Customer", "Shops online via web/mobile")
    Person(admin, "Admin", "Manages products, orders, and platform")
    Person(merchant, "Merchant", "Manages inventory and fulfillment")

    System_Boundary(yaniq, "YaniQ Platform") {
        System(web, "Web Application", "React/Angular SPA")
        System(mobile, "Mobile Apps", "iOS/Android Native")
        System(api, "API Gateway", "Spring Cloud Gateway")
        System(services, "Microservices", "22+ Business Services")
        System(data, "Data Layer", "PostgreSQL, Redis, Elasticsearch")
        System(events, "Event Streaming", "Apache Kafka")
    }

    System_Ext(payment, "Payment Gateway", "Stripe, PayPal")
    System_Ext(shipping, "Shipping Provider", "FedEx, UPS")
    System_Ext(email, "Email Service", "SendGrid, AWS SES")
    System_Ext(sms, "SMS Service", "Twilio")

    Rel(customer, web, "Uses")
    Rel(customer, mobile, "Uses")
    Rel(admin, web, "Manages")
    Rel(merchant, web, "Uses")
    
    Rel(web, api, "HTTPS/JSON")
    Rel(mobile, api, "HTTPS/JSON")
    Rel(api, services, "Routes requests")
    Rel(services, data, "Reads/Writes")
    Rel(services, events, "Pub/Sub")
    
    Rel(services, payment, "Processes payments")
    Rel(services, shipping, "Books shipments")
    Rel(services, email, "Sends emails")
    Rel(services, sms, "Sends SMS")
```

### Logical Architecture Layers

```mermaid
flowchart TD
    subgraph "Presentation Layer"
        WEB[Web Application<br/>React/Angular]
        MOBILE[Mobile Apps<br/>iOS/Android]
        ADMIN[Admin Portal<br/>React]
    end

    subgraph "API Gateway Layer"
        GW[API Gateway<br/>Spring Cloud Gateway]
        AUTH_FILTER[Authentication Filter]
        RATE_LIMIT[Rate Limiter]
        CIRCUIT[Circuit Breaker]
    end

    subgraph "Service Discovery Layer"
        EUREKA[Eureka Server<br/>Service Registry]
    end

    subgraph "Application Layer - Core Services"
        AUTH[Auth Service]
        USER[User Service]
        NOTIF[Notification Service]
    end

    subgraph "Application Layer - Business Services"
        PRODUCT[Product Service]
        CART[Cart Service]
        ORDER[Order Service]
        PAYMENT[Payment Service]
        INVENTORY[Inventory Service]
        SHIPPING[Shipping Service]
        REVIEW[Review Service]
    end

    subgraph "Application Layer - Supporting Services"
        PROMO[Promotion Service]
        ANALYTICS[Analytics Service]
        SEARCH[Search Service]
        RECOMMEND[Recommendation Service]
        LOYALTY[Loyalty Service]
        SUPPORT[Support Service]
    end

    subgraph "Integration Layer"
        KAFKA[Apache Kafka<br/>Event Streaming]
        REDIS[Redis<br/>Caching & Session]
    end

    subgraph "Data Layer"
        POSTGRES[(PostgreSQL<br/>Per Service DB)]
        ELASTIC[(Elasticsearch<br/>Search Index)]
    end

    subgraph "Observability Layer"
        PROMETHEUS[Prometheus<br/>Metrics]
        GRAFANA[Grafana<br/>Dashboards]
        ELK[ELK Stack<br/>Logging]
        JAEGER[Jaeger<br/>Tracing]
    end

    WEB --> GW
    MOBILE --> GW
    ADMIN --> GW
    
    GW --> AUTH_FILTER
    AUTH_FILTER --> RATE_LIMIT
    RATE_LIMIT --> CIRCUIT
    CIRCUIT --> AUTH
    CIRCUIT --> USER
    CIRCUIT --> PRODUCT
    CIRCUIT --> CART
    CIRCUIT --> ORDER
    
    AUTH -.->|Register| EUREKA
    USER -.->|Register| EUREKA
    PRODUCT -.->|Register| EUREKA
    CART -.->|Register| EUREKA
    ORDER -.->|Register| EUREKA
    PAYMENT -.->|Register| EUREKA
    
    GW -.->|Discover| EUREKA
    
    ORDER --> KAFKA
    PAYMENT --> KAFKA
    INVENTORY --> KAFKA
    KAFKA --> NOTIF
    
    PRODUCT --> REDIS
    CART --> REDIS
    AUTH --> REDIS
    
    PRODUCT --> ELASTIC
    SEARCH --> ELASTIC
    
    AUTH --> POSTGRES
    USER --> POSTGRES
    PRODUCT --> POSTGRES
    ORDER --> POSTGRES
    PAYMENT --> POSTGRES
    
    AUTH -.-> PROMETHEUS
    USER -.-> PROMETHEUS
    PRODUCT -.-> PROMETHEUS
    PROMETHEUS --> GRAFANA
    
    AUTH -.-> ELK
    USER -.-> ELK
    
    AUTH -.-> JAEGER
    ORDER -.-> JAEGER

    style EUREKA fill:#00FF00,stroke:#006400,stroke-width:3px
    style GW fill:#87CEEB,stroke:#4682B4,stroke-width:2px
    style KAFKA fill:#FF6B6B,stroke:#C92A2A,stroke-width:2px
    style POSTGRES fill:#336791,stroke:#1A3A52,stroke-width:2px
    style REDIS fill:#DC382D,stroke:#8B0000,stroke-width:2px
```

---

## 🎯 Architecture Principles

### 1. **Domain-Driven Design (DDD)**
- Services organized around business domains
- Bounded contexts for each microservice
- Ubiquitous language within teams
- Aggregate roots for data consistency

### 2. **Microservices Patterns**
- **Single Responsibility**: Each service has one clear purpose
- **Loose Coupling**: Services are independent and loosely coupled
- **High Cohesion**: Related functionality grouped together
- **Autonomous**: Services can be deployed independently

### 3. **API-First Design**
- OpenAPI/Swagger specifications
- Contract-first development
- Versioned APIs
- RESTful principles with HATEOAS

### 4. **Event-Driven Architecture**
- Asynchronous communication via events
- Event sourcing for audit trails
- CQRS for read/write separation
- Eventual consistency

### 5. **Cloud-Native Principles**
- 12-Factor App methodology
- Containerized deployments
- Infrastructure as Code
- Horizontal scalability

### 6. **Security by Design**
- Zero-trust security model
- Defense in depth
- Principle of least privilege
- Encryption at rest and in transit

### 7. **Resilience & Fault Tolerance**
- Circuit breaker pattern
- Retry mechanisms with exponential backoff
- Bulkhead isolation
- Graceful degradation

### 8. **Observability**
- Distributed tracing
- Centralized logging
- Metrics and monitoring
- Health checks

---

## 🧩 Core Components

### 1. API Gateway (Port 8080)

**Purpose**: Single entry point for all client requests

**Responsibilities**:
- Request routing and composition
- Authentication and authorization
- Rate limiting and throttling
- Request/response transformation
- Protocol translation (REST, WebSocket)
- API versioning
- CORS handling

**Technology**: Spring Cloud Gateway

**Features**:
```yaml
- Dynamic routing based on service discovery
- Predicate-based routing rules
- Filter chains for request/response processing
- Circuit breaker integration
- Retry and timeout configuration
- Load balancing
```

### 2. Service Discovery (Port 8761) ✅

**Purpose**: Dynamic service registration and discovery

**Responsibilities**:
- Service registration
- Health monitoring
- Service lookup
- Load balancing metadata

**Technology**: Netflix Eureka Server

**Status**: Production Ready

### 3. Configuration Service (Planned)

**Purpose**: Centralized configuration management

**Responsibilities**:
- Externalized configuration
- Environment-specific properties
- Dynamic configuration refresh
- Secret management

**Technology**: Spring Cloud Config Server

### 4. Authentication Service (Port 8081)

**Purpose**: User authentication and authorization

**Responsibilities**:
- User login/logout
- JWT token generation and validation
- Password management
- OAuth2 integration
- Multi-factor authentication (planned)

**Technology**: Spring Security, JWT

### 5. Business Services

Detailed breakdown of each business service:

#### Product Service (Port 8083)
- Product catalog management
- Category hierarchy
- Product attributes and variants
- Image and media management
- Pricing and inventory integration

#### Order Service (Port 8084)
- Order creation and processing
- Order status tracking
- Order history
- Integration with payment, inventory, and shipping

#### Payment Service (Port 8085)
- Payment processing
- Multiple payment gateways
- Transaction management
- Refund processing
- Payment method management

#### Cart Service (Port 8086)
- Shopping cart CRUD operations
- Cart item management
- Price calculations
- Redis-backed for performance

#### Inventory Service (Port 8087)
- Stock level tracking
- Inventory updates
- Low stock alerts
- Multi-warehouse support

---

## 🕸️ Service Mesh Architecture

### Service-to-Service Communication

```mermaid
flowchart LR
    subgraph "Client Services"
        GW[API Gateway]
    end

    subgraph "Service Discovery"
        EUREKA[Eureka Server]
    end

    subgraph "Service Instances"
        direction TB
        PRODUCT1[Product-1]
        PRODUCT2[Product-2]
        PRODUCT3[Product-3]
    end

    subgraph "Load Balancer"
        LB[Spring Cloud LoadBalancer]
    end

    GW -->|1. Discover| EUREKA
    EUREKA -->|2. Return Instances| GW
    GW --> LB
    LB -->|Round Robin| PRODUCT1
    LB -->|Round Robin| PRODUCT2
    LB -->|Round Robin| PRODUCT3

    style EUREKA fill:#00FF00,stroke:#006400,stroke-width:2px
    style LB fill:#FFD700,stroke:#FF8C00,stroke-width:2px
```

### Future: Istio Service Mesh (Planned)

- **Traffic Management**: Advanced routing, load balancing
- **Security**: mTLS between services
- **Observability**: Enhanced tracing and metrics
- **Policy Enforcement**: Access control, rate limiting

---

## 🎨 Design Patterns

### 1. API Gateway Pattern

**Problem**: Direct client-to-service communication causes coupling and complexity

**Solution**: Single entry point that routes requests to appropriate services

**Benefits**:
- Simplified client code
- Centralized authentication
- Protocol translation
- Request aggregation

### 2. Service Registry Pattern

**Problem**: Hard-coded service locations are inflexible

**Solution**: Dynamic service registration and discovery (Eureka)

**Benefits**:
- Dynamic scaling
- Service health monitoring
- Location transparency
- Load balancing support

### 3. Circuit Breaker Pattern

**Problem**: Cascading failures can bring down entire system

**Solution**: Resilience4j circuit breaker wraps service calls

**Benefits**:
- Fail fast when service is down
- Automatic recovery
- Fallback mechanisms
- System stability

**Implementation**:
```java
@CircuitBreaker(name = "productService", fallbackMethod = "getProductFallback")
public Product getProduct(Long id) {
    return productClient.getProduct(id);
}

public Product getProductFallback(Long id, Exception ex) {
    return Product.builder()
        .id(id)
        .name("Product Temporarily Unavailable")
        .build();
}
```

### 4. Saga Pattern

**Problem**: Distributed transactions across microservices

**Solution**: Choreography-based saga using Kafka events

**Example: Order Processing Saga**

```mermaid
sequenceDiagram
    participant Order
    participant Payment
    participant Inventory
    participant Shipping
    participant Notification

    Order->>+Payment: OrderCreated Event
    Payment->>Payment: Process Payment
    alt Payment Success
        Payment->>Inventory: PaymentCompleted Event
        Inventory->>Inventory: Reserve Stock
        alt Stock Available
            Inventory->>Shipping: StockReserved Event
            Shipping->>Shipping: Create Shipment
            Shipping->>Notification: ShipmentCreated Event
            Notification->>Notification: Send Order Confirmation
        else Stock Unavailable
            Inventory->>Payment: StockReservationFailed Event
            Payment->>Payment: Refund Payment
            Payment->>Order: PaymentRefunded Event
            Order->>Notification: OrderCancelled Event
        end
    else Payment Failed
        Payment->>Order: PaymentFailed Event
        Order->>Notification: OrderFailed Event
    end
```

### 5. CQRS (Command Query Responsibility Segregation)

**Problem**: Different read and write requirements

**Solution**: Separate models for reads and writes

**Benefits**:
- Optimized for specific use cases
- Better performance
- Scalability
- Simplified queries

### 6. Event Sourcing

**Problem**: Need for audit trail and historical data

**Solution**: Store events as the source of truth

**Benefits**:
- Complete audit log
- Temporal queries
- Event replay
- Debugging capabilities

### 7. Database per Service

**Problem**: Shared database creates coupling

**Solution**: Each service owns its database

**Benefits**:
- Service independence
- Technology diversity
- Schema evolution
- Scalability

### 8. Strangler Fig Pattern

**Problem**: Migrating legacy systems

**Solution**: Gradually replace old system with new services

**Benefits**:
- Incremental migration
- Reduced risk
- Continuous delivery

---

## 📡 Communication Patterns

### Synchronous Communication (REST)

**Use Cases**:
- Client-to-service via API Gateway
- Service-to-service for immediate responses
- CRUD operations

**Technology**: Spring WebMVC, Spring WebFlux, Feign Client

**Example**:
```java
@FeignClient(name = "product-service")
public interface ProductClient {
    @GetMapping("/api/products/{id}")
    Product getProduct(@PathVariable Long id);
}
```

### Asynchronous Communication (Events)

**Use Cases**:
- Event notifications
- Background processing
- Cross-service data synchronization
- Audit logging

**Technology**: Apache Kafka, Spring Cloud Stream

**Example**:
```java
@Component
public class OrderEventPublisher {
    
    @Autowired
    private KafkaTemplate<String, OrderEvent> kafkaTemplate;
    
    public void publishOrderCreated(Order order) {
        OrderEvent event = new OrderEvent(order);
        kafkaTemplate.send("order-events", event);
    }
}

@Component
public class OrderEventListener {
    
    @KafkaListener(topics = "order-events", groupId = "inventory-service")
    public void handleOrderCreated(OrderEvent event) {
        // Reserve inventory
    }
}
```

### Communication Decision Matrix

| Scenario | Pattern | Technology | Reason |
|----------|---------|------------|--------|
| User places order | Synchronous | REST | Immediate response needed |
| Send order confirmation | Asynchronous | Kafka | Fire and forget |
| Update inventory | Asynchronous | Kafka | Eventual consistency OK |
| Get product details | Synchronous | REST | Real-time data required |
| Process payment | Synchronous | REST | Immediate confirmation needed |
| Analytics update | Asynchronous | Kafka | Background processing |

---

## 💾 Data Architecture

### Database Strategy

#### 1. Database per Service

Each microservice has its own database schema:

```yaml
Services and Their Databases:
  auth-service:
    database: auth_db
    tables: [users, roles, permissions, tokens]
  
  user-service:
    database: user_db
    tables: [user_profiles, addresses, preferences]
  
  product-service:
    database: product_db
    tables: [products, categories, variants, images]
  
  order-service:
    database: order_db
    tables: [orders, order_items, order_status_history]
  
  payment-service:
    database: payment_db
    tables: [transactions, payment_methods, refunds]
  
  inventory-service:
    database: inventory_db
    tables: [stock_levels, warehouses, stock_movements]
```

#### 2. Caching Strategy

**Redis Usage**:
- Session storage
- Product catalog cache
- Shopping cart persistence
- Rate limiting counters
- Distributed locks

**Cache Pattern**:
```java
@Cacheable(value = "products", key = "#id")
public Product getProduct(Long id) {
    return productRepository.findById(id)
        .orElseThrow(() -> new ProductNotFoundException(id));
}

@CacheEvict(value = "products", key = "#product.id")
public Product updateProduct(Product product) {
    return productRepository.save(product);
}
```

#### 3. Search Index

**Elasticsearch Usage**:
- Product full-text search
- Faceted search and filtering
- Auto-complete suggestions
- Analytics and aggregations

### Data Consistency Patterns

#### Strong Consistency
- Within service boundaries
- ACID transactions in PostgreSQL
- For critical operations (payments)

#### Eventual Consistency
- Cross-service data
- Event-driven updates
- For non-critical operations (analytics)

#### Saga Pattern
- Distributed transactions
- Compensating transactions
- For business workflows (order processing)

---

## 🔒 Security Architecture

### Security Layers

```mermaid
flowchart TD
    CLIENT[Client Application]
    
    subgraph "Perimeter Security"
        WAF[Web Application Firewall]
        DDoS[DDoS Protection]
    end
    
    subgraph "API Gateway Security"
        AUTH_FILTER[Authentication Filter]
        AUTHZ[Authorization]
        RATE[Rate Limiting]
        CORS[CORS Policy]
    end
    
    subgraph "Service Security"
        JWT_VAL[JWT Validation]
        RBAC[Role-Based Access Control]
        DATA_VAL[Input Validation]
    end
    
    subgraph "Data Security"
        ENCRYPT[Encryption at Rest]
        TLS[TLS/SSL]
        MASK[Data Masking]
    end
    
    CLIENT --> WAF
    WAF --> DDoS
    DDoS --> AUTH_FILTER
    AUTH_FILTER --> AUTHZ
    AUTHZ --> RATE
    RATE --> CORS
    CORS --> JWT_VAL
    JWT_VAL --> RBAC
    RBAC --> DATA_VAL
    DATA_VAL --> ENCRYPT
    ENCRYPT --> TLS
    TLS --> MASK

    style AUTH_FILTER fill:#FF6B6B,stroke:#C92A2A,stroke-width:2px
    style ENCRYPT fill:#51CF66,stroke:#2B8A3E,stroke-width:2px
```

### Authentication Flow

```mermaid
sequenceDiagram
    participant Client
    participant Gateway
    participant Auth
    participant Service
    participant DB

    Client->>Gateway: POST /api/auth/login<br/>{username, password}
    Gateway->>Auth: Forward Request
    Auth->>DB: Validate Credentials
    DB-->>Auth: User Details
    Auth->>Auth: Generate JWT Token
    Auth-->>Gateway: {accessToken, refreshToken}
    Gateway-->>Client: Return Tokens
    
    Note over Client: Store Tokens Securely
    
    Client->>Gateway: GET /api/products<br/>Authorization: Bearer {token}
    Gateway->>Gateway: Validate JWT
    Gateway->>Service: Forward with User Context
    Service-->>Gateway: Product Data
    Gateway-->>Client: Response
```

### Security Features

✅ **Authentication**
- JWT-based authentication
- OAuth2 integration (planned)
- Multi-factor authentication (planned)
- Session management

✅ **Authorization**
- Role-based access control (RBAC)
- Permission-based access
- Resource-level authorization
- API key authentication (for external APIs)

✅ **Data Protection**
- Encryption at rest (database)
- TLS/SSL for data in transit
- Sensitive data masking
- PII data protection

✅ **API Security**
- Rate limiting per user/IP
- CORS configuration
- Input validation
- SQL injection prevention
- XSS protection

---

## 🛡️ Resilience & Fault Tolerance

### Resilience Patterns Implementation

```mermaid
flowchart TB
    REQUEST[Incoming Request]
    
    subgraph "Resilience4j Patterns"
        CB[Circuit Breaker]
        RETRY[Retry Mechanism]
        BULK[Bulkhead]
        RATE_LIMIT[Rate Limiter]
        TIMEOUT[Timeout]
    end
    
    FALLBACK[Fallback Response]
    SUCCESS[Successful Response]
    
    REQUEST --> CB
    CB -->|Open| FALLBACK
    CB -->|Closed/Half-Open| RETRY
    RETRY -->|Failed| FALLBACK
    RETRY -->|Success| BULK
    BULK --> RATE_LIMIT
    RATE_LIMIT --> TIMEOUT
    TIMEOUT -->|Timeout| FALLBACK
    TIMEOUT -->|Success| SUCCESS

    style CB fill:#FF6B6B,stroke:#C92A2A,stroke-width:2px
    style SUCCESS fill:#51CF66,stroke:#2B8A3E,stroke-width:2px
    style FALLBACK fill:#FFA500,stroke:#FF8C00,stroke-width:2px
```

### Configuration Example

```yaml
resilience4j:
  circuitbreaker:
    instances:
      productService:
        registerHealthIndicator: true
        slidingWindowSize: 10
        minimumNumberOfCalls: 5
        permittedNumberOfCallsInHalfOpenState: 3
        automaticTransitionFromOpenToHalfOpenEnabled: true
        waitDurationInOpenState: 5s
        failureRateThreshold: 50
        eventConsumerBufferSize: 10
  
  retry:
    instances:
      productService:
        maxAttempts: 3
        waitDuration: 1s
        exponentialBackoffMultiplier: 2
        retryExceptions:
          - org.springframework.web.client.HttpServerErrorException
          - java.net.ConnectException
  
  bulkhead:
    instances:
      productService:
        maxConcurrentCalls: 10
        maxWaitDuration: 0
  
  ratelimiter:
    instances:
      productService:
        limitForPeriod: 100
        limitRefreshPeriod: 1s
        timeoutDuration: 0
```

---

## 📊 Observability Architecture

### Three Pillars of Observability

```mermaid
flowchart LR
    subgraph "Microservices"
        S1[Service 1]
        S2[Service 2]
        S3[Service 3]
    end
    
    subgraph "Metrics"
        PROM[Prometheus]
        GRAF[Grafana]
    end
    
    subgraph "Logging"
        LOG[Logstash]
        ES[Elasticsearch]
        KIB[Kibana]
    end
    
    subgraph "Tracing"
        OTEL[OpenTelemetry]
        JAEG[Jaeger]
    end
    
    S1 -->|Metrics| PROM
    S2 -->|Metrics| PROM
    S3 -->|Metrics| PROM
    PROM --> GRAF
    
    S1 -->|Logs| LOG
    S2 -->|Logs| LOG
    S3 -->|Logs| LOG
    LOG --> ES
    ES --> KIB
    
    S1 -->|Traces| OTEL
    S2 -->|Traces| OTEL
    S3 -->|Traces| OTEL
    OTEL --> JAEG

    style PROM fill:#E6522C,stroke:#CC4A29,stroke-width:2px
    style GRAF fill:#F46800,stroke:#D85F00,stroke-width:2px
    style ES fill:#005571,stroke:#003D52,stroke-width:2px
```

### Monitoring Stack

**1. Metrics (Prometheus + Grafana)**
- Application metrics (request rate, error rate, duration)
- JVM metrics (heap, GC, threads)
- Custom business metrics
- Infrastructure metrics

**2. Logging (ELK Stack)**
- Centralized log aggregation
- Structured logging with JSON
- Log correlation with trace IDs
- Log-based alerting

**3. Tracing (OpenTelemetry + Jaeger)**
- Distributed request tracing
- Service dependency mapping
- Latency analysis
- Error tracking

---

## 🚀 Deployment Architecture

### Container Orchestration

```mermaid
flowchart TB
    subgraph "Kubernetes Cluster"
        subgraph "Namespace: yaniq-prod"
            subgraph "Deployment: discovery-service"
                DS1[discovery-pod-1]
                DS2[discovery-pod-2]
            end
            
            subgraph "Deployment: gateway-service"
                GW1[gateway-pod-1]
                GW2[gateway-pod-2]
                GW3[gateway-pod-3]
            end
            
            subgraph "Deployment: auth-service"
                AUTH1[auth-pod-1]
                AUTH2[auth-pod-2]
            end
            
            subgraph "Deployment: product-service"
                PROD1[product-pod-1]
                PROD2[product-pod-2]
                PROD3[product-pod-3]
            end
        end
        
        subgraph "Services"
            SVC_DS[discovery-svc]
            SVC_GW[gateway-svc]
            SVC_AUTH[auth-svc]
            SVC_PROD[product-svc]
        end
        
        INGRESS[Ingress Controller]
    end
    
    LB[Load Balancer]
    
    LB --> INGRESS
    INGRESS --> SVC_GW
    
    SVC_DS --> DS1
    SVC_DS --> DS2
    
    SVC_GW --> GW1
    SVC_GW --> GW2
    SVC_GW --> GW3
    
    SVC_AUTH --> AUTH1
    SVC_AUTH --> AUTH2
    
    SVC_PROD --> PROD1
    SVC_PROD --> PROD2
    SVC_PROD --> PROD3

    style INGRESS fill:#326CE5,stroke:#1A4D9F,stroke-width:2px
    style LB fill:#FF6B6B,stroke:#C92A2A,stroke-width:2px
```

### Deployment Strategies

**1. Rolling Deployment** (Default)
- Zero-downtime deployments
- Gradual instance replacement
- Automatic rollback on failure

**2. Blue-Green Deployment** (Planned)
- Two identical environments
- Instant switchover
- Easy rollback

**3. Canary Deployment** (Planned)
- Gradual traffic shift
- Risk mitigation
- A/B testing capability

---

## 📚 Related Documentation

- 🚀 [Getting Started](./GETTING_STARTED.md)
- ⚙️ [Configuration Guide](./CONFIGURATION.md)
- 🚢 [Deployment Guide](./DEPLOYMENT.md)
- 🔍 [Discovery Service](./services/DISCOVERY_SERVICE.md)
- 🌐 [API Documentation](./SWAGGER_DOCUMENTATION.md)

---

<div align="center">

**System Architecture** | **YaniQ E-Commerce Platform**

[⬆ Back to Top](#-system-architecture) | [📖 Main Documentation](./README.md)

</div>
