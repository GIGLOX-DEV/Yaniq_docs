---
layout: default
title: Services
nav_order: 3
has_children: true
permalink: /services/
description: "Complete documentation for all YaniQ microservices"
---

# YaniQ Microservices
{: .fs-9 }

Comprehensive documentation for all 22+ microservices in the YaniQ platform.
{: .fs-6 .fw-300 }

---

## 📊 Service Overview

The YaniQ platform consists of **22+ microservices** organized into three main categories:

- **Core Services** - Essential infrastructure services (Discovery, Gateway, Auth)
- **Business Services** - Domain-specific business logic (Product, Order, Payment)
- **Supporting Services** - Value-added functionality (Analytics, Search, Recommendations)

---

## 🏗️ Core Services

These services form the foundation of the YaniQ platform and must be running for the system to function.

### 🔍 Discovery Service
**Port:** 8761 | **Status:** ✅ Active | **Type:** Infrastructure

Netflix Eureka-based service registry for dynamic service discovery and health monitoring.

- Service registration and discovery
- Health check monitoring
- Load balancing support
- Self-preservation mode

[View Documentation →](/services/DISCOVERY_SERVICE)

---

### 🌐 Gateway Service  
**Port:** 8080 | **Status:** ✅ Active | **Type:** Infrastructure

Spring Cloud Gateway providing API routing, authentication, rate limiting, and circuit breaking.

- Centralized API routing
- JWT authentication
- Rate limiting
- Circuit breaker pattern
- CORS configuration

[View Documentation →](/services/GATEWAY_SERVICE)

---

### 🔐 Auth Service
**Port:** 8081 | **Status:** ✅ Active | **Type:** Core

Authentication and authorization service with OAuth2 and JWT token management.

- User authentication (login/logout)
- JWT token generation & validation
- Refresh token management
- Role-based access control (RBAC)
- Password management

[View Documentation →](/services/AUTH_SERVICE)

---

### 📧 Notification Service
**Port:** 8088 | **Status:** ✅ Active | **Type:** Core

Multi-channel notification service supporting email, SMS, and push notifications.

- Email notifications (transactional & marketing)
- SMS notifications
- Push notifications (mobile)
- Template management
- Notification history

[View Documentation →](/services/NOTIFICATION_SERVICE)

---

## 💼 Business Services

Domain-specific services implementing core e-commerce business logic.

### 👤 User Service
**Port:** 8082 | **Status:** 🚧 In Development | **Type:** Business

User profile and account management service.

- User registration and profiles
- Profile management
- Address management
- Preference management
- Account deletion

[View Documentation →](/services/USER_SERVICE)

---

### 📦 Product Service
**Port:** 8083 | **Status:** 🚧 In Development | **Type:** Business

Product catalog and inventory management.

- Product CRUD operations
- Category management
- Product variants
- Image management
- Pricing and discounts

[View Documentation →](/services/PRODUCT_SERVICE)

---

### 🛒 Cart Service
**Port:** 8086 | **Status:** 🚧 In Development | **Type:** Business

Shopping cart management with session persistence.

- Add/remove items
- Update quantities
- Cart persistence
- Session management
- Cart abandonment tracking

[View Documentation →](/services/CART_SERVICE)

---

### 📋 Order Service
**Port:** 8084 | **Status:** 🚧 In Development | **Type:** Business

Order processing and lifecycle management.

- Order creation
- Order status tracking
- Order history
- Invoice generation
- Order cancellation

[View Documentation →](/services/ORDER_SERVICE)

---

### 💳 Payment Service
**Port:** 8085 | **Status:** 🚧 In Development | **Type:** Business

Payment processing with multiple payment gateway integrations.

- Payment processing
- Gateway integration (Stripe, PayPal)
- Payment status tracking
- Refund management
- Payment history

[View Documentation →](/services/PAYMENT_SERVICE)

---

### 📊 Inventory Service
**Port:** 8087 | **Status:** 🚧 In Development | **Type:** Business

Real-time inventory and stock management.

- Stock tracking
- Warehouse management
- Stock alerts
- Reservation system
- Stock history

[View Documentation →](/services/INVENTORY_SERVICE)

---

### 🚚 Shipping Service
**Port:** 8090 | **Status:** 📋 Planned | **Type:** Business

Shipping and logistics management.

- Shipping calculation
- Carrier integration
- Tracking management
- Delivery scheduling
- Returns processing

[View Documentation →](/services/SHIPPING_SERVICE)

---

## 🎯 Supporting Services

Value-added services that enhance the platform functionality.

### 📊 Analytics Service
**Port:** 8089 | **Status:** 📋 Planned | **Type:** Supporting

Business intelligence and analytics service.

- Sales analytics
- User behavior tracking
- Performance metrics
- Custom reports
- Data visualization

[View Documentation →](/services/ANALYTICS_SERVICE)

---

### 🔍 Search Service
**Port:** 8091 | **Status:** 📋 Planned | **Type:** Supporting

Elasticsearch-powered product search and filtering.

- Full-text search
- Faceted search
- Auto-suggestions
- Search analytics
- Relevance tuning

[View Documentation →](/services/SEARCH_SERVICE)

---

### ⭐ Review Service
**Port:** 8092 | **Status:** 📋 Planned | **Type:** Supporting

Product reviews and ratings management.

- Review submission
- Rating management
- Review moderation
- Helpful votes
- Review analytics

[View Documentation →](/services/REVIEW_SERVICE)

---

### 🎯 Recommendation Service
**Port:** 8093 | **Status:** 📋 Planned | **Type:** Supporting

AI-powered product recommendations.

- Personalized recommendations
- Similar products
- Trending products
- Cross-sell/upsell
- Collaborative filtering

[View Documentation →](/services/RECOMMENDATION_SERVICE)

---

### 🎁 Promotion Service
**Port:** 8094 | **Status:** 📋 Planned | **Type:** Supporting

Promotions, discounts, and coupon management.

- Coupon management
- Discount rules
- Promotional campaigns
- Flash sales
- Loyalty rewards

[View Documentation →](/services/PROMOTION_SERVICE)

---

### 🎫 Loyalty Service
**Port:** 8095 | **Status:** 📋 Planned | **Type:** Supporting

Customer loyalty and rewards program.

- Points management
- Tier management
- Reward redemption
- Referral program
- Gamification

[View Documentation →](/services/LOYALTY_SERVICE)

---

### 🎧 Support Service
**Port:** 8096 | **Status:** 📋 Planned | **Type:** Supporting

Customer support and ticketing system.

- Ticket management
- Live chat
- FAQ management
- Support analytics
- SLA tracking

[View Documentation →](/services/SUPPORT_SERVICE)

---

## 📊 Service Status Legend

| Icon | Status | Description |
|------|--------|-------------|
| ✅ | **Active** | Service is fully operational and in production |
| 🚧 | **In Development** | Service is being actively developed |
| 📋 | **Planned** | Service is planned for future development |
| ⚠️ | **Maintenance** | Service is under maintenance |
| ❌ | **Deprecated** | Service is being phased out |

---

## 🔄 Inter-Service Communication

Services communicate through:

- **Synchronous:** REST APIs via API Gateway
- **Asynchronous:** Apache Kafka event streaming
- **Service Discovery:** Eureka for dynamic service location
- **Circuit Breaking:** Resilience4j for fault tolerance

[Learn more about communication patterns →](/MESSAGING_GUIDE)

---

## 🏗️ Service Architecture Pattern

Each service follows a consistent architecture:

```
Service/
├── Controller Layer    → REST API endpoints
├── Service Layer       → Business logic
├── Repository Layer    → Data access
├── DTO Layer          → Data transfer objects
├── Entity Layer       → Domain models
├── Configuration      → Service configuration
└── Tests              → Unit & integration tests
```

[View Architecture Details →](/ARCHITECTURE)

---

## 🚀 Quick Start

To run all services locally:

```bash
# Start infrastructure services
docker-compose -f docker-compose.dev.yml up -d

# Build all services
mvn clean install

# Run Discovery Service
cd apps/discovery-service && mvn spring-boot:run

# Run Gateway Service
cd apps/gateway-service && mvn spring-boot:run

# Run other services...
```

[View Complete Getting Started Guide →](/GETTING_STARTED)

---

## 📚 Related Documentation

- [Architecture Overview](/ARCHITECTURE) - System design patterns
- [Configuration Guide](/CONFIGURATION) - Service configuration
- [Deployment Guide](/DEPLOYMENT) - Production deployment
- [API Documentation](/api-documentation) - REST API reference
- [Messaging Guide](/MESSAGING_GUIDE) - Event-driven patterns

---

{: .note }
> **Development Status:** Core services (Discovery, Gateway, Auth, Notification) are active. Business services are under active development. Supporting services are in planning phase.
