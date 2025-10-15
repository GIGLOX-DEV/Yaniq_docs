---
layout: default
title: API Documentation
nav_order: 5
description: "REST API documentation for all YaniQ microservices"
---

# API Documentation
{: .no_toc }

Complete REST API documentation for all YaniQ microservices.

## Table of Contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Overview

YaniQ provides RESTful APIs for all microservices. All APIs follow consistent patterns and standards.

### Base URL Structure

```
https://api.yaniq.com/api/v1/{service}/{resource}
```

### Authentication

Most endpoints require authentication using JWT tokens:

```bash
Authorization: Bearer <your-jwt-token>
```

Get your token from the [Auth Service](services/AUTH_SERVICE.md).

---

## Core Services APIs

### Gateway Service

**Base URL:** `http://localhost:8080`

The API Gateway routes requests to appropriate microservices.

### Discovery Service

**Base URL:** `http://localhost:8761`

Service registry and discovery using Netflix Eureka.

### Auth Service

**Base URL:** `http://localhost:8081/api/v1/auth`

#### Login
{: .api-endpoint }

<span class="api-method method-post">POST</span> `/login`

Authenticate user and receive JWT token.

**Request Body:**
```json
{
  "username": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "refresh-token-here",
  "expiresIn": 3600,
  "user": {
    "id": "user-id",
    "username": "user@example.com",
    "roles": ["ROLE_USER"]
  }
}
```

#### Register
{: .api-endpoint }

<span class="api-method method-post">POST</span> `/register`

Register a new user account.

**Request Body:**
```json
{
  "username": "newuser@example.com",
  "password": "SecurePassword123!",
  "firstName": "John",
  "lastName": "Doe"
}
```

---

## Business Services APIs

### Product Service

**Base URL:** `http://localhost:8082/api/v1/products`

#### Get All Products
{: .api-endpoint }

<span class="api-method method-get">GET</span> `/`

Retrieve all products with pagination.

**Query Parameters:**
- `page` (integer): Page number (default: 0)
- `size` (integer): Page size (default: 20)
- `sort` (string): Sort field (default: "createdAt")
- `category` (string): Filter by category

**Response:**
```json
{
  "content": [
    {
      "id": "prod-123",
      "name": "Product Name",
      "description": "Product description",
      "price": 99.99,
      "category": "electronics",
      "stock": 100,
      "images": ["url1", "url2"]
    }
  ],
  "page": 0,
  "size": 20,
  "totalElements": 100,
  "totalPages": 5
}
```

#### Get Product by ID
{: .api-endpoint }

<span class="api-method method-get">GET</span> `/{id}`

Retrieve a specific product by ID.

#### Create Product
{: .api-endpoint }

<span class="api-method method-post">POST</span> `/`

Create a new product (Admin only).

**Request Body:**
```json
{
  "name": "New Product",
  "description": "Product description",
  "price": 99.99,
  "category": "electronics",
  "stock": 100
}
```

#### Update Product
{: .api-endpoint }

<span class="api-method method-put">PUT</span> `/{id}`

Update an existing product.

#### Delete Product
{: .api-endpoint }

<span class="api-method method-delete">DELETE</span> `/{id}`

Delete a product (Admin only).

---

### Order Service

**Base URL:** `http://localhost:8083/api/v1/orders`

#### Create Order
{: .api-endpoint }

<span class="api-method method-post">POST</span> `/`

Create a new order from cart items.

**Request Body:**
```json
{
  "cartId": "cart-123",
  "shippingAddress": {
    "street": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zipCode": "10001",
    "country": "USA"
  },
  "paymentMethod": "CREDIT_CARD"
}
```

#### Get User Orders
{: .api-endpoint }

<span class="api-method method-get">GET</span> `/user/{userId}`

Retrieve all orders for a specific user.

#### Get Order by ID
{: .api-endpoint }

<span class="api-method method-get">GET</span> `/{id}`

Retrieve order details.

#### Update Order Status
{: .api-endpoint }

<span class="api-method method-patch">PATCH</span> `/{id}/status`

Update order status (Admin only).

---

### Cart Service

**Base URL:** `http://localhost:8084/api/v1/cart`

#### Get Cart
{: .api-endpoint }

<span class="api-method method-get">GET</span> `/{userId}`

Get user's shopping cart.

#### Add Item to Cart
{: .api-endpoint }

<span class="api-method method-post">POST</span> `/{userId}/items`

Add product to cart.

**Request Body:**
```json
{
  "productId": "prod-123",
  "quantity": 2
}
```

#### Update Cart Item
{: .api-endpoint }

<span class="api-method method-put">PUT</span> `/{userId}/items/{itemId}`

Update quantity of cart item.

#### Remove Item from Cart
{: .api-endpoint }

<span class="api-method method-delete">DELETE</span> `/{userId}/items/{itemId}`

Remove item from cart.

#### Clear Cart
{: .api-endpoint }

<span class="api-method method-delete">DELETE</span> `/{userId}`

Clear all items from cart.

---

### Payment Service

**Base URL:** `http://localhost:8085/api/v1/payments`

#### Process Payment
{: .api-endpoint }

<span class="api-method method-post">POST</span> `/process`

Process payment for an order.

**Request Body:**
```json
{
  "orderId": "order-123",
  "amount": 199.99,
  "currency": "USD",
  "paymentMethod": "CREDIT_CARD",
  "cardDetails": {
    "cardNumber": "4111111111111111",
    "expiryMonth": "12",
    "expiryYear": "2025",
    "cvv": "123"
  }
}
```

#### Get Payment Status
{: .api-endpoint }

<span class="api-method method-get">GET</span> `/{paymentId}`

Check payment status.

---

### User Service

**Base URL:** `http://localhost:8086/api/v1/users`

#### Get User Profile
{: .api-endpoint }

<span class="api-method method-get">GET</span> `/{userId}`

Retrieve user profile information.

#### Update User Profile
{: .api-endpoint }

<span class="api-method method-put">PUT</span> `/{userId}`

Update user profile.

#### Get User Addresses
{: .api-endpoint }

<span class="api-method method-get">GET</span> `/{userId}/addresses`

Get saved addresses.

#### Add Address
{: .api-endpoint }

<span class="api-method method-post">POST</span> `/{userId}/addresses`

Add new shipping address.

---

## API Standards

### Response Format

All API responses follow this structure:

**Success Response:**
```json
{
  "success": true,
  "data": { },
  "message": "Operation successful",
  "timestamp": "2024-10-15T04:00:00Z"
}
```

**Error Response:**
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Error description",
    "details": []
  },
  "timestamp": "2024-10-15T04:00:00Z"
}
```

### HTTP Status Codes

| Code | Description |
|------|-------------|
| 200 | Success |
| 201 | Created |
| 204 | No Content |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 409 | Conflict |
| 500 | Internal Server Error |

### Rate Limiting

API requests are rate-limited:
- **Standard users:** 100 requests/minute
- **Premium users:** 1000 requests/minute
- **Admin users:** No limit

### Pagination

Paginated endpoints support these query parameters:
- `page`: Page number (0-indexed)
- `size`: Items per page
- `sort`: Sort field and direction (e.g., `createdAt,desc`)

### Filtering

Use query parameters for filtering:
```
GET /api/v1/products?category=electronics&minPrice=50&maxPrice=500
```

### Versioning

APIs are versioned in the URL path:
```
/api/v1/...
/api/v2/...
```

## Testing APIs

### Using cURL

```bash
# Login
curl -X POST http://localhost:8081/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user@example.com","password":"password123"}'

# Get products
curl -X GET http://localhost:8082/api/v1/products \
  -H "Authorization: Bearer <token>"
```

### Using Postman

Import our [Postman collection](assets/YaniQ_API.postman_collection.json) for easy testing.

### Swagger UI

Interactive API documentation available at:
```
http://localhost:8080/swagger-ui.html
```

## Additional Resources

- [Service Documentation](services/services.md)
- [Authentication Guide](services/AUTH_SERVICE.md)
- [Error Handling](../guides/TROUBLESHOOTING.md)
- [Architecture Overview](../guides/ARCHITECTURE.md)

---

**Last Updated:** October 15, 2024
