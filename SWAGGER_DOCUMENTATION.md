# YaniQ E-Commerce Microservices - Swagger UI API Documentation

🚀 **Complete API documentation setup for all YaniQ microservices using OpenAPI 3.0 and Swagger UI**

## 📋 Overview

This documentation system provides comprehensive API documentation for all 22 microservices in the YaniQ e-commerce platform. Each service has its own Swagger UI interface with detailed endpoint documentation, request/response schemas, and interactive testing capabilities.

## 🏗️ Architecture

- **Framework**: Spring Boot 3.5.5 with Java 21
- **Documentation**: OpenAPI 3.0 / Swagger UI via SpringDoc
- **Authentication**: OAuth2 + JWT Bearer tokens
- **Service Discovery**: Eureka Server
- **Message Queue**: RabbitMQ
- **Databases**: PostgreSQL per service
- **Caching**: Redis

## 🎯 Quick Start

### 1. Automatic Setup (Recommended)
```bash
# Run the automated setup script
./scripts/setup-swagger.sh
```

### 2. Manual Setup for Individual Services
```bash
# Add SpringDoc dependency to pom.xml
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
</dependency>

# Add configuration to application.yml
springdoc:
  api-docs:
    path: /api-docs
    enabled: true
  swagger-ui:
    path: /swagger-ui.html
    enabled: true
```

### 3. Start Services with Docker Compose
```bash
# Start all services with databases and infrastructure
docker-compose -f docker-compose.swagger.yml up -d

# Or start individual services
mvn spring-boot:run -f apps/auth-service/pom.xml
mvn spring-boot:run -f apps/user-service/pom.xml
```

## 🌐 Service Documentation URLs

### Core Services (Active)
| Service | Port | Swagger UI | OpenAPI Spec | Status |
|---------|------|------------|--------------|--------|
| **Authentication Service** | 8081 | [Swagger UI](http://localhost:8081/swagger-ui.html) | [API Docs](http://localhost:8081/api-docs) | ✅ Active |
| **User Management Service** | 8082 | [Swagger UI](http://localhost:8082/swagger-ui.html) | [API Docs](http://localhost:8082/api-docs) | ✅ Active |
| **Gateway Service** | 8080 | [Swagger UI](http://localhost:8080/swagger-ui.html) | [API Docs](http://localhost:8080/api-docs) | ✅ Active |
| **Discovery Service** | 8761 | [Eureka Dashboard](http://localhost:8761) | [Health](http://localhost:8761/actuator/health) | ✅ Active |
| **Notification Service** | 8088 | [Swagger UI](http://localhost:8088/swagger-ui.html) | [API Docs](http://localhost:8088/api-docs) | ✅ Active |

### Business Services (In Development)
| Service | Port | Swagger UI | OpenAPI Spec | Status |
|---------|------|------------|--------------|--------|
| **Product Service** | 8083 | [Swagger UI](http://localhost:8083/swagger-ui.html) | [API Docs](http://localhost:8083/api-docs) | 🚧 In Dev |
| **Order Service** | 8084 | [Swagger UI](http://localhost:8084/swagger-ui.html) | [API Docs](http://localhost:8084/api-docs) | 🚧 In Dev |
| **Payment Service** | 8085 | [Swagger UI](http://localhost:8085/swagger-ui.html) | [API Docs](http://localhost:8085/api-docs) | 🚧 In Dev |
| **Cart Service** | 8086 | [Swagger UI](http://localhost:8086/swagger-ui.html) | [API Docs](http://localhost:8086/api-docs) | 🚧 In Dev |
| **Inventory Service** | 8087 | [Swagger UI](http://localhost:8087/swagger-ui.html) | [API Docs](http://localhost:8087/api-docs) | 🚧 In Dev |
| **Analytics Service** | 8089 | [Swagger UI](http://localhost:8089/swagger-ui.html) | [API Docs](http://localhost:8089/api-docs) | 🚧 In Dev |

### 🎨 Centralized Documentation Hub
Access the beautiful API documentation hub at: **[http://localhost:3000](http://localhost:3000)**

## 🔧 Features Implemented

### ✅ What's Been Added:

1. **SpringDoc OpenAPI 3.0 Dependencies**
   - Added to parent pom.xml for centralized version management
   - Individual service configurations

2. **Comprehensive API Documentation**
   - **Authentication Service**: Login, logout, token refresh, password reset
   - **User Management Service**: CRUD operations, profiles, roles
   - Detailed request/response schemas with examples
   - Security requirements and authentication flows

3. **OpenAPI Configuration Classes**
   - Base configuration for consistent documentation
   - Service-specific customizations
   - Security schemes (JWT, OAuth2, Basic Auth)

4. **Enhanced Application Properties**
   - SpringDoc configurations for Swagger UI
   - Management endpoints for health checks
   - Actuator metrics integration

5. **Development Infrastructure**
   - Docker Compose setup with all services
   - Database containers for each service
   - RabbitMQ and Redis for messaging/caching
   - Nginx-served documentation hub

6. **Automation Scripts**
   - `setup-swagger.sh` for automated dependency injection
   - Bulk configuration management

## 📚 API Documentation Examples

### Authentication Service APIs:
- `POST /api/v1/auth/login` - User authentication
- `POST /api/v1/auth/logout` - Session termination  
- `POST /api/v1/auth/refresh` - Token refresh
- `POST /api/v1/auth/forgot-password` - Password recovery
- `POST /api/v1/auth/validate` - Token validation

### User Management Service APIs:
- `GET /api/v1/users` - List all users (paginated)
- `GET /api/v1/users/{userId}` - Get user by ID
- `POST /api/v1/users` - Create new user
- `PUT /api/v1/users/{userId}` - Update user
- `DELETE /api/v1/users/{userId}` - Delete user
- `GET /api/v1/users/{userId}/profile` - Get user profile

## 🚀 Next Steps

### To Complete the Setup:

1. **Build the Project**
   ```bash
   mvn clean install
   ```

2. **Start Infrastructure Services**
   ```bash
   docker-compose -f docker-compose.swagger.yml up -d postgres-auth postgres-user rabbitmq redis eureka-server
   ```

3. **Start Application Services**
   ```bash
   # Start auth service
   cd apps/auth-service && mvn spring-boot:run
   
   # Start user service  
   cd apps/user-service && mvn spring-boot:run
   ```

4. **Access Documentation**
   - Main Hub: http://localhost:3000
   - Auth Service: http://localhost:8081/swagger-ui.html
   - User Service: http://localhost:8082/swagger-ui.html

### For Additional Services:

1. Run the setup script: `./scripts/setup-swagger.sh`
2. Add service-specific controller implementations
3. Customize OpenAPI configurations as needed
4. Update the documentation hub with new service links

## 🎨 Visual Features

- **Beautiful Documentation Hub**: Modern, responsive design with service status indicators
- **Interactive Swagger UI**: Try-it-out functionality for all endpoints
- **Comprehensive Schemas**: Detailed request/response documentation with examples
- **Security Integration**: OAuth2 and JWT authentication flows
- **Health Monitoring**: Actuator endpoints for service health checks

## 📞 Support

For questions or issues:
- **Email**: danukajihansanath0408@gmail.com
- **Documentation**: `/docs` directory
- **Architecture Guide**: `docs/ARCHITECTURE.md`
- **Deployment Guide**: `docs/DEPLOYMENT.md`

---

**🎉 Your YaniQ microservices now have comprehensive, professional API documentation with Swagger UI!**
