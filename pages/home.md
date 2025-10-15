---
layout: default
title: Documentation Home
nav_order: 1
description: "YaniQ Platform Documentation - Main navigation and overview"
permalink: /
---

# YaniQ Enterprise E-Commerce Platform

Welcome to the comprehensive documentation for YaniQ - A cloud-native microservices-based e-commerce platform built with Spring Boot, Spring Cloud, and modern DevOps practices.

## 🚀 Quick Navigation

<div class="quick-links">
  <a href="{{ '/pages/getting-started/pages/getting-started/GETTING_STARTED.html' | relative_url }}" class="quick-link">
    <strong>🎯 Getting Started</strong>
    <p>Setup and quick start guide</p>
  </a>
  
  <a href="{{ '/pages/guides/pages/guides/ARCHITECTURE.html' | relative_url }}" class="quick-link">
    <strong>🏗️ Architecture</strong>
    <p>System design and patterns</p>
  </a>
  
  <a href="{{ '/services/services.html' | relative_url }}" class="quick-link">
    <strong>🔧 Services</strong>
    <p>22 microservices documentation</p>
  </a>
  
  <a href="{{ '/LIBRARIES/libraries.html' | relative_url }}" class="quick-link">
    <strong>📚 Libraries</strong>
    <p>14 shared libraries</p>
  </a>
  
  <a href="{{ '/pages/reference/pages/reference/api-documentation.html' | relative_url }}" class="quick-link">
    <strong>📡 API Reference</strong>
    <p>Complete REST API docs</p>
  </a>
  
  <a href="{{ '/pages/guides/pages/guides/DEPLOYMENT.html' | relative_url }}" class="quick-link">
    <strong>🚢 Deployment</strong>
    <p>Docker, K8s, and cloud</p>
  </a>
</div>

## 📖 Documentation Sections

### [Getting Started](pages/getting-started/)
{: .text-delta }

Quick start guides and tutorials to get you up and running with YaniQ.

- [Getting Started Guide](pages/getting-started/pages/getting-started/GETTING_STARTED.html)
- System prerequisites
- Local development setup
- First deployment

### [Guides](pages/guides/)
{: .text-delta }

Comprehensive guides for all aspects of the platform.

- [Architecture Overview](pages/guides/pages/guides/ARCHITECTURE.html)
- [Configuration Guide](pages/guides/pages/guides/CONFIGURATION.html)
- [Deployment Guide](pages/guides/pages/guides/DEPLOYMENT.html)
- [Messaging Guide](pages/guides/MESSAGING_GUIDE.html)
- [Troubleshooting](pages/guides/pages/guides/TROUBLESHOOTING.html)
- [Security](pages/guides/security.html)
- [Observability](pages/guides/observability.html)
- [Operations](pages/guides/operations.html)
- [Infrastructure](pages/guides/infrastructure.html)
- [CI/CD](pages/guides/ci-cd.html)

### [Services](services/services.html)
{: .text-delta }

Documentation for all 22 microservices in the platform.

**Core Services:**
- [Auth Service](services/AUTH_SERVICE.html)
- [Gateway Service](services/GATEWAY_SERVICE.html)
- [Discovery Service](services/DISCOVERY_SERVICE.html)

**Business Services:**
- [Product Service](services/PRODUCT-SERVICE.html)
- [Order Service](services/ORDER-SERVICE.html)
- [Cart Service](services/CART-SERVICE.html)
- [Payment Service](services/PAYMENT-SERVICE.html)
- [Inventory Service](services/INVENTORY-SERVICE.html)
- [User Service](services/USER-SERVICE.html)

**Support Services:**
- [Notification Service](services/NOTIFICATION-SERVICE.html)
- [Review Service](services/REVIEW-SERVICE.html)
- [Search Service](services/SEARCH-SERVICE.html)
- [Shipping Service](services/SHIPPING-SERVICE.html)
- [And 9 more...](services/services.html)

### [Libraries](LIBRARIES/libraries.html)
{: .text-delta }

Shared libraries and reusable components.

- [Common API](LIBRARIES/common-api/index.html)
- [Common Security](LIBRARIES/common-security/index.html)
- [Common Messaging](LIBRARIES/common-messaging/index.html)
- [Common Logging](LIBRARIES/common-logging/index.html)
- [And 10 more...](LIBRARIES/libraries.html)

### [API Reference](pages/reference/)
{: .text-delta }

Complete REST API documentation.

- [API Documentation](pages/reference/pages/reference/api-documentation.html)
- [Documentation Index](pages/reference/DOCUMENTATION_INDEX.html)
- Authentication & Authorization
- All service endpoints
- Request/Response examples

### [Contributing](pages/contributing/)
{: .text-delta }

How to contribute to YaniQ.

- [Contributing Guide](pages/contributing/pages/contributing/CONTRIBUTING.html)
- [Quick Reference](pages/contributing/QUICK_REFERENCE.html)
- [Setup Guide](pages/contributing/SETUP_COMPLETE.html)
- [Developer Help](pages/contributing/Dev-Help.html)

## 🎯 Key Features

<div class="feature-list">
  <div class="feature-item">
    <h3>🏗️ Microservices Architecture</h3>
    <p>22+ independent services for maximum flexibility and scalability</p>
  </div>
  
  <div class="feature-item">
    <h3>🔐 Enterprise Security</h3>
    <p>OAuth2, JWT, and role-based access control built-in</p>
  </div>
  
  <div class="feature-item">
    <h3>☁️ Cloud-Native</h3>
    <p>Docker, Kubernetes, and cloud-ready deployments</p>
  </div>
  
  <div class="feature-item">
    <h3>📊 Observability</h3>
    <p>Comprehensive monitoring, logging, and tracing</p>
  </div>
</div>

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/GIGLOX-DEV/YaniQ.git
cd YaniQ

# Start with Docker Compose
docker-compose up -d

# Or run individual services
cd apps/gateway-service
mvn spring-boot:run
```

See the [Getting Started Guide](pages/getting-started/pages/getting-started/GETTING_STARTED.html) for detailed instructions.

## 📊 Platform Statistics

| Component | Count |
|-----------|-------|
| Microservices | 22 |
| Shared Libraries | 14 |
| REST API Endpoints | 200+ |
| Spring Boot Version | 3.5.5 |
| Java Version | 21 |
| Spring Cloud Version | 2025.0.0 |

## 🛠️ Technology Stack

- **Backend:** Java 21, Spring Boot 3.5, Spring Cloud
- **Messaging:** RabbitMQ, Apache Kafka
- **Databases:** PostgreSQL, MongoDB, Redis
- **Monitoring:** Prometheus, Grafana, ELK Stack
- **Containers:** Docker, Kubernetes
- **CI/CD:** Jenkins, GitHub Actions

## 📞 Support & Resources

- 📖 [Documentation](pages/reference/DOCUMENTATION_INDEX.html)
- 💬 [GitHub Discussions](https://github.com/GIGLOX-DEV/YaniQ/discussions)
- 🐛 [Report Issues](https://github.com/GIGLOX-DEV/YaniQ/issues)
- 📧 [Email Support](mailto:support@yaniq.com)

## 📄 License

This project is licensed under the [Apache License 2.0](LICENSE.txt).

---

**Built with ❤️ by the YaniQ Team**

© 2024-2025 YaniQ Enterprise. All rights reserved.
