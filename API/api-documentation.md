---
layout: default
title: API Documentation
nav_order: 4
description: "Complete REST API reference for YaniQ microservices"
permalink: /api-documentation/
---

# API Documentation
{: .fs-9 }

Complete REST API reference for all YaniQ microservices with interactive Swagger UI.
{: .fs-6 .fw-300 }

[Open Swagger UI](/swagger-ui.html){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 }

---

## 🌐 API Gateway

All API requests should go through the API Gateway at `http://localhost:8080`

### Base URLs

| Environment | Base URL | Description |
|-------------|----------|-------------|
| **Local Development** | `http://localhost:8080/api` | Local machine |
| **Development** | `https://dev-api.yaniq.com/api` | Development environment |
| **Staging** | `https://staging-api.yaniq.com/api` | Pre-production testing |
| **Production** | `https://api.yaniq.com/api` | Production environment |

---

## 🔐 Authentication

YaniQ uses **JWT (JSON Web Tokens)** for authentication.

### Getting a Token

```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "user@example.com",
  "password": "yourPassword123"
}
```

**Response:**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "tokenType": "Bearer",
  "expiresIn": 86400
}
```

### Using the Token

Include the token in the Authorization header for all authenticated requests:

```http
GET /api/products
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## 📡 Core API Endpoints

### Auth Service (`/api/auth`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/auth/login` | User login | ❌ |
| POST | `/auth/register` | User registration | ❌ |
| POST | `/auth/refresh` | Refresh access token | ✅ |
| POST | `/auth/logout` | User logout | ✅ |
| POST | `/auth/forgot-password` | Request password reset | ❌ |
| POST | `/auth/reset-password` | Reset password | ❌ |
| GET | `/auth/verify-email` | Verify email address | ❌ |

[View Full Auth API Documentation →](/services/AUTH_SERVICE#api-endpoints)

---

### User Service (`/api/users`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/users/me` | Get current user profile | ✅ |
| PUT | `/users/me` | Update user profile | ✅ |
| DELETE | `/users/me` | Delete user account | ✅ |
| GET | `/users/{id}` | Get user by ID | ✅ Admin |
| GET | `/users` | List all users | ✅ Admin |
| POST | `/users/{id}/addresses` | Add address | ✅ |
| GET | `/users/me/addresses` | Get user addresses | ✅ |

[View Full User API Documentation →](/services/USER_SERVICE#api-endpoints)

---

### Product Service (`/api/products`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/products` | List all products | ❌ |
| GET | `/products/{id}` | Get product by ID | ❌ |
| POST | `/products` | Create product | ✅ Admin |
| PUT | `/products/{id}` | Update product | ✅ Admin |
| DELETE | `/products/{id}` | Delete product | ✅ Admin |
| GET | `/products/search` | Search products | ❌ |
| GET | `/products/category/{id}` | Get products by category | ❌ |

[View Full Product API Documentation →](/services/PRODUCT_SERVICE#api-endpoints)

---

### Cart Service (`/api/cart`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/cart` | Get user's cart | ✅ |
| POST | `/cart/items` | Add item to cart | ✅ |
| PUT | `/cart/items/{id}` | Update cart item | ✅ |
| DELETE | `/cart/items/{id}` | Remove item from cart | ✅ |
| DELETE | `/cart` | Clear cart | ✅ |
| POST | `/cart/checkout` | Checkout cart | ✅ |

[View Full Cart API Documentation →](/services/CART_SERVICE#api-endpoints)

---

### Order Service (`/api/orders`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/orders` | Create order | ✅ |
| GET | `/orders` | List user orders | ✅ |
| GET | `/orders/{id}` | Get order details | ✅ |
| PUT | `/orders/{id}/cancel` | Cancel order | ✅ |
| GET | `/orders/{id}/invoice` | Get order invoice | ✅ |
| PUT | `/orders/{id}/status` | Update order status | ✅ Admin |

[View Full Order API Documentation →](/services/ORDER_SERVICE#api-endpoints)

---

### Payment Service (`/api/payments`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/payments` | Process payment | ✅ |
| GET | `/payments/{id}` | Get payment status | ✅ |
| POST | `/payments/{id}/refund` | Refund payment | ✅ Admin |
| GET | `/payments/methods` | Get payment methods | ✅ |
| POST | `/payments/methods` | Add payment method | ✅ |

[View Full Payment API Documentation →](/services/PAYMENT_SERVICE#api-endpoints)

---

## 📊 Request & Response Formats

### Standard Request Format

```json
{
  "data": {
    // Request payload
  },
  "metadata": {
    "requestId": "uuid",
    "timestamp": "2025-10-14T12:00:00Z"
  }
}
```

### Standard Response Format

**Success Response:**
```json
{
  "success": true,
  "data": {
    // Response data
  },
  "metadata": {
    "timestamp": "2025-10-14T12:00:00Z",
    "requestId": "uuid"
  }
}
```

**Error Response:**
```json
{
  "success": false,
  "error": {
    "code": "PRODUCT_NOT_FOUND",
    "message": "Product with ID 12345 not found",
    "details": {}
  },
  "metadata": {
    "timestamp": "2025-10-14T12:00:00Z",
    "requestId": "uuid"
  }
}
```

---

## 🔄 Pagination

List endpoints support pagination with the following query parameters:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `page` | integer | 0 | Page number (0-based) |
| `size` | integer | 20 | Items per page (max 100) |
| `sort` | string | - | Sort field and direction (e.g., `name,asc`) |

**Example:**
```http
GET /api/products?page=0&size=20&sort=createdAt,desc
```

**Response:**
```json
{
  "success": true,
  "data": {
    "content": [...],
    "pageable": {
      "pageNumber": 0,
      "pageSize": 20,
      "totalPages": 5,
      "totalElements": 100
    }
  }
}
```

---

## 🔍 Filtering & Searching

### Query Parameters

Most list endpoints support filtering:

```http
GET /api/products?category=electronics&minPrice=100&maxPrice=500&inStock=true
```

### Search

Full-text search using the `q` parameter:

```http
GET /api/products/search?q=laptop&category=electronics
```

---

## 🚨 Error Codes

| HTTP Status | Error Code | Description |
|-------------|------------|-------------|
| 400 | `BAD_REQUEST` | Invalid request format or parameters |
| 401 | `UNAUTHORIZED` | Missing or invalid authentication token |
| 403 | `FORBIDDEN` | Insufficient permissions |
| 404 | `NOT_FOUND` | Resource not found |
| 409 | `CONFLICT` | Resource conflict (e.g., duplicate) |
| 422 | `VALIDATION_ERROR` | Request validation failed |
| 429 | `RATE_LIMIT_EXCEEDED` | Too many requests |
| 500 | `INTERNAL_ERROR` | Internal server error |
| 503 | `SERVICE_UNAVAILABLE` | Service temporarily unavailable |

---

## 🔐 Rate Limiting

API requests are rate-limited to ensure fair usage:

| Tier | Requests per Minute | Requests per Hour |
|------|-------------------|------------------|
| **Anonymous** | 60 | 1,000 |
| **Authenticated** | 300 | 10,000 |
| **Premium** | 1,000 | 50,000 |

Rate limit headers are included in all responses:

```http
X-RateLimit-Limit: 300
X-RateLimit-Remaining: 285
X-RateLimit-Reset: 1697289600
```

---

## 🌐 CORS Policy

Cross-Origin Resource Sharing (CORS) is enabled for the following origins:

- `http://localhost:3000` (Development)
- `https://app.yaniq.com` (Production)
- `https://admin.yaniq.com` (Admin Portal)

---

## 📝 Interactive API Documentation

### Swagger UI

Access interactive API documentation with Swagger UI:

**Local:** [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)

Features:
- Browse all API endpoints
- Try out requests directly in the browser
- View request/response schemas
- Download OpenAPI specification

### OpenAPI Specification

Download the OpenAPI 3.0 specification:

```http
GET /api/v3/api-docs
```

---

## 🧪 Testing with Postman

Import the Postman collection for quick API testing:

1. Download collection: [YaniQ API Collection](./assets/YaniQ-API-Collection.json)
2. Import into Postman
3. Set environment variables:
   - `baseUrl`: `http://localhost:8080`
   - `accessToken`: Your JWT token

---

## 📚 SDK & Client Libraries

Official SDK support (coming soon):

- **JavaScript/TypeScript** - NPM package
- **Python** - PyPI package
- **Java** - Maven dependency
- **PHP** - Composer package

---

## 🔗 Related Documentation

- [Authentication Service](/services/AUTH_SERVICE) - Detailed auth documentation
- [Services Overview](/services) - All microservices
- [Getting Started](/GETTING_STARTED) - Setup guide
- [Architecture](/ARCHITECTURE) - System architecture

---

{: .note }
> **API Version:** v1 | **Last Updated:** October 2025 | **OpenAPI:** 3.0.3

{: .highlight }
> For production use, always use HTTPS and never expose sensitive credentials in your code or logs.
