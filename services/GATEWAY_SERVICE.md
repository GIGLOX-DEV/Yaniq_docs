---
layout: default
title: Gateway Service
parent: Services
nav_order: 2
description: "API Gateway for routing, auth, rate limiting, and resilience"
permalink: /services/GATEWAY_SERVICE/
---

# Gateway Service

## Overview

The Gateway Service is an API gateway that provides routing, authentication, rate limiting, and resilience for microservices. It acts as a single entry point for all client requests, routing them to the appropriate backend services. The gateway also handles authentication and authorization, ensuring that only valid requests are forwarded to the services. Additionally, it provides rate limiting to prevent abuse and ensure fair usage among clients. The gateway is designed to be resilient, with built-in retries, circuit breakers, and fallback mechanisms to handle service failures gracefully.

## Features

- Routing to backend microservices
- Authentication and authorization (JWT/OAuth2)
- Rate limiting and quotas
- Circuit breaker and retries
- Centralized logging and metrics

## Configuration (YAML)

A valid Spring Cloud Gateway configuration using service discovery and common filters:

```yaml
spring:
  cloud:
    gateway:
      discovery:
        locator:
          enabled: true
          lower-case-service-id: true
      routes:
        # Auth Service
        - id: auth-service
          uri: lb://auth-service
          predicates:
            - Path=/api/auth/**
          filters:
            - StripPrefix=1
        
        # User Service
        - id: user-service
          uri: lb://user-service
          predicates:
            - Path=/api/users/**
          filters:
            - StripPrefix=1
            - name: CircuitBreaker
              args:
                name: userServiceCircuitBreaker
                fallbackUri: forward:/fallback/users
        
        # Product Service
        - id: product-service
          uri: lb://product-service
          predicates:
            - Path=/api/products/**
          filters:
            - StripPrefix=1
            - name: RequestRateLimiter
              args:
                redis-rate-limiter.replenishRate: 10
                redis-rate-limiter.burstCapacity: 20
                key-resolver: "#{@ipKeyResolver}"
  
  redis:
    host: ${REDIS_HOST:localhost}
    port: ${REDIS_PORT:6379}
```

## API

The Gateway Service exposes actuator endpoints for inspecting routes and metrics, for example:

- GET /actuator/gateway/routes
- GET /actuator/gateway/routes/{id}
- POST /actuator/gateway/refresh

## Getting Started

- Ensure Discovery Service (Eureka) is running
- Configure routes as shown above
- Start the gateway application and verify health at /actuator/health

## Troubleshooting

- 503 errors: ensure downstream services are registered in Eureka
- CORS issues: configure global CORS in gateway settings
- Rate limit exceeded: review Redis connectivity and limiter settings
