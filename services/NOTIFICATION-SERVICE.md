---
layout: default
title: Notification Service
parent: Services
nav_order: 12
description: "Notification Service microservice documentation"
---

# Notification Service
{: .no_toc }

## Table of Contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Overview

The **Notification Service** is a core microservice in the YaniQ e-commerce platform.

### Key Features

- Feature 1
- Feature 2
- Feature 3

## Configuration

### Application Properties

```yaml
server:
  port: 8082
spring:
  application:
    name: notification-service
```

## API Endpoints

### Base URL

```
http://localhost:8082/api
```

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /health | Health check endpoint |
| GET | /info | Service information |

## Dependencies

This service depends on:

- Discovery Service (Eureka)
- Config Service
- Database

## Local Development

### Prerequisites

- Java 21+
- Maven 3.9+
- Docker (optional)

### Running Locally

```bash
cd apps/notification-service
mvn clean install
mvn spring-boot:run
```

### Running with Docker

```bash
docker build -t yaniq/notification-service .
docker run -p 8082:8082 yaniq/notification-service
```

## Testing

### Unit Tests

```bash
mvn test
```

### Integration Tests

```bash
mvn verify
```

## Monitoring

### Health Check

```bash
curl http://localhost:8082/actuator/health
```

### Metrics

```bash
curl http://localhost:8082/actuator/metrics
```

## Troubleshooting

### Common Issues

1. **Service fails to start**
   - Check if required dependencies are running
   - Verify configuration in Config Service

2. **Connection timeouts**
   - Verify network connectivity
   - Check firewall settings

## Related Services

- [Gateway Service](GATEWAY_SERVICE.md)
- [Discovery Service](DISCOVERY_SERVICE.md)
- [Auth Service](AUTH_SERVICE.md)

## Additional Resources

- [Architecture Overview](../pages/guides/ARCHITECTURE.md)
- [Configuration Guide](../pages/guides/CONFIGURATION.md)
- [Deployment Guide](../pages/guides/DEPLOYMENT.md)

---

**Last Updated:** 2025-10-15
