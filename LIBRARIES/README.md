# 📚 YaniQ Shared Libraries

<div align="center">

![Libraries](https://img.shields.io/badge/Libraries-14%20Modules-blue?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active%20Development-green?style=for-the-badge)
![Java](https://img.shields.io/badge/Java-21-orange?style=for-the-badge)

**Reusable Components and Utilities for YaniQ Microservices**

[Overview](#-overview) •
[Libraries](#-available-libraries) •
[Usage](#-usage) •
[Best Practices](#-best-practices) •
[Contributing](#-contributing)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Why Shared Libraries](#-why-shared-libraries)
- [Available Libraries](#-available-libraries)
- [Getting Started](#-getting-started)
- [Usage Examples](#-usage-examples)
- [Best Practices](#-best-practices)
- [Library Development](#-library-development)
- [Contributing](#-contributing)

---

## 🌟 Overview

The YaniQ platform uses a collection of **shared libraries** to promote code reuse, consistency, and maintainability across all microservices. These libraries provide common functionality that every service needs, from logging to security to messaging.

### Key Benefits

✅ **Code Reuse** - Write once, use everywhere  
✅ **Consistency** - Standardized patterns across services  
✅ **Maintainability** - Single source of truth for common functionality  
✅ **Productivity** - Faster service development  
✅ **Quality** - Well-tested, production-ready components  

---

## 🎯 Why Shared Libraries?

### Without Shared Libraries ❌
```
Each service implements its own:
- Logging (inconsistent formats)
- Error handling (different exceptions)
- API responses (varied structures)
- Validation (duplicated logic)
- Security (potential vulnerabilities)
```

### With Shared Libraries ✅
```
All services use:
- Common Logging (unified format)
- Common Exceptions (standard errors)
- Common API (consistent responses)
- Common Validation (reusable validators)
- Common Security (centralized auth)
```

---

## 📦 Available Libraries

### ✅ Production Ready Libraries

#### 1. Common Logging
**Status**: ✅ Active | **Version**: 2.0  
**Purpose**: Unified logging framework with multiple strategies

**Features**:
- 📝 **Multiple Strategies**: Console, ELK, File, Structured JSON
- 🎯 **Structured Logging**: Key-value pairs for easy parsing
- 🔍 **Performance Tracking**: Built-in performance logging
- 🔒 **Security Logging**: Dedicated security event logging
- 📊 **Metrics Integration**: Custom metrics logging
- ⚡ **Async Processing**: Non-blocking log operations

**Maven Dependency**:
```xml
<dependency>
    <groupId>com.yaniq</groupId>
    <artifactId>common-logging</artifactId>
    <version>2.0</version>
</dependency>
```

**Quick Example**:
```java
CommonLogger logger = CommonLogger.getLogger(MyService.class);
logger.info("User authenticated | userId: {} | duration: {}ms", userId, duration);
logger.performance("database_query", 150, "Table: {} | Records: {}", tableName, count);
```

📖 **[Complete Documentation](./logging/common-logging-api.md)**

---

#### 2. Common Audit
**Status**: ✅ Active | **Version**: 1.0  
**Purpose**: Audit trail tracking for compliance and security

**Features**:
- 📋 **Event Tracking**: Record all user actions
- 🕒 **Temporal Queries**: Query audit history
- 🔐 **Compliance Ready**: GDPR, SOX, HIPAA support
- 📊 **Reporting**: Built-in audit reports
- 🔍 **Search & Filter**: Advanced audit log querying

**Maven Dependency**:
```xml
<dependency>
    <groupId>com.yaniq</groupId>
    <artifactId>common-audit</artifactId>
    <version>1.0</version>
</dependency>
```

**Quick Example**:
```java
@Audited(action = "USER_DELETE", category = "USER_MANAGEMENT")
public void deleteUser(Long userId) {
    // Method automatically audited
}
```

---

#### 3. Common Exceptions
**Status**: ✅ Active | **Version**: 1.0  
**Purpose**: Standardized exception handling and error responses

**Features**:
- 🎯 **Custom Exceptions**: Business-specific exceptions
- 📝 **Standard Error Format**: Consistent error responses
- 🌍 **I18n Support**: Internationalized error messages
- 🔍 **Error Tracking**: Integration with monitoring tools
- 📊 **Error Analytics**: Error frequency and patterns

**Maven Dependency**:
```xml
<dependency>
    <groupId>com.yaniq</groupId>
    <artifactId>common-exceptions</artifactId>
    <version>1.0</version>
</dependency>
```

**Quick Example**:
```java
throw new ResourceNotFoundException("Product", "id", productId);
throw new BusinessException("INSUFFICIENT_STOCK", "Product out of stock");
```

---

#### 4. Common Messaging
**Status**: ✅ Active | **Version**: 1.0  
**Purpose**: Kafka event handling and message processing

**Features**:
- 📨 **Event Publishing**: Easy event publishing to Kafka
- 📥 **Event Consumption**: Simplified event consumption
- 🔄 **Retry Logic**: Automatic retry with backoff
- 💾 **Dead Letter Queue**: Failed message handling
- 📊 **Message Tracking**: End-to-end message tracing

**Maven Dependency**:
```xml
<dependency>
    <groupId>com.yaniq</groupId>
    <artifactId>common-messaging</artifactId>
    <version>1.0</version>
</dependency>
```

**Quick Example**:
```java
// Publishing events
eventPublisher.publish("order-events", new OrderCreatedEvent(order));

// Consuming events
@KafkaListener(topics = "order-events")
public void handleOrderCreated(OrderCreatedEvent event) {
    // Process event
}
```

---

#### 5. Common API
**Status**: ✅ Active | **Version**: 1.0  
**Purpose**: REST API utilities and standardized responses

**Features**:
- 📦 **Response Wrappers**: Consistent API responses
- 📄 **Pagination**: Standardized pagination support
- 🔍 **Filtering**: Query parameter filtering
- 📊 **Sorting**: Multi-field sorting
- ⚠️ **Error Responses**: Uniform error format

**Maven Dependency**:
```xml
<dependency>
    <groupId>com.yaniq</groupId>
    <artifactId>common-api</artifactId>
    <version>1.0</version>
</dependency>
```

**Quick Example**:
```java
@GetMapping("/products")
public ApiResponse<Page<Product>> getProducts(Pageable pageable) {
    Page<Product> products = productService.findAll(pageable);
    return ApiResponse.success(products);
}
```

---

### 🚧 Libraries in Development

#### 6. Common Security
**Status**: 🚧 In Development | **Version**: 0.9  
**Purpose**: JWT utilities, authentication filters, and security configurations

**Planned Features**:
- 🔐 **JWT Utilities**: Token generation and validation
- 🛡️ **Auth Filters**: Request authentication filters
- 👥 **Role Management**: RBAC implementation
- 🔒 **Encryption**: Data encryption utilities
- 🔑 **Key Management**: Secure key storage

**Maven Dependency** (when released):
```xml
<dependency>
    <groupId>com.yaniq</groupId>
    <artifactId>common-security</artifactId>
    <version>0.9</version>
</dependency>
```

---

#### 7. Common Cache
**Status**: 🚧 In Development | **Version**: 0.8  
**Purpose**: Redis caching abstractions and distributed cache utilities

**Planned Features**:
- 💾 **Cache Annotations**: Simple caching with annotations
- 🔄 **Cache Invalidation**: Smart cache invalidation
- 📊 **Cache Statistics**: Cache hit/miss metrics
- 🌐 **Distributed Locking**: Redis-based distributed locks
- ⏱️ **TTL Management**: Flexible time-to-live configuration

---

#### 8. Common Validation
**Status**: 🚧 In Development | **Version**: 0.7  
**Purpose**: Input validation, custom validators, and sanitization

**Planned Features**:
- ✅ **Custom Validators**: Business-specific validation rules
- 🧹 **Input Sanitization**: XSS and SQL injection prevention
- 📋 **Validation Groups**: Context-specific validation
- 🌍 **I18n Messages**: Internationalized validation messages
- 📊 **Validation Reports**: Detailed validation error reports

---

#### 9. Common Utils
**Status**: 🚧 In Development | **Version**: 0.6  
**Purpose**: Date/time utilities, string helpers, and collection utilities

**Planned Features**:
- 📅 **Date Utilities**: Date formatting and parsing
- 🔤 **String Helpers**: String manipulation utilities
- 📊 **Collection Utils**: Collection processing helpers
- 🔢 **Number Utils**: Number formatting and validation
- 🔄 **Conversion Utils**: Type conversion utilities

---

#### 10. Common Config
**Status**: 🚧 In Development | **Version**: 0.5  
**Purpose**: Configuration management and property loaders

---

#### 11. Common DTO
**Status**: 🚧 In Development | **Version**: 0.5  
**Purpose**: Data Transfer Objects and mapping utilities

---

#### 12. Common Events
**Status**: 🚧 In Development | **Version**: 0.4  
**Purpose**: Domain events and event sourcing patterns

---

#### 13. Common Models
**Status**: 🚧 In Development | **Version**: 0.4  
**Purpose**: Shared domain models and base entities

---

#### 14. Common Test
**Status**: 🚧 In Development | **Version**: 0.3  
**Purpose**: Testing utilities, mocks, and test containers

**Planned Features**:
- 🧪 **Test Utilities**: Common test helpers
- 🎭 **Mock Objects**: Pre-configured mocks
- 🐳 **Test Containers**: Docker-based test containers
- 📊 **Test Data Builders**: Fluent test data creation
- 🔍 **Assertion Helpers**: Custom assertions

---

## 🚀 Getting Started

### Adding Libraries to Your Service

#### 1. Add to Parent POM (Already configured)

The parent POM manages all library versions:

```xml
<dependencyManagement>
    <dependencies>
        <!-- Shared Libraries -->
        <dependency>
            <groupId>com.yaniq</groupId>
            <artifactId>common-logging</artifactId>
            <version>2.0</version>
        </dependency>
        <dependency>
            <groupId>com.yaniq</groupId>
            <artifactId>common-audit</artifactId>
            <version>1.0</version>
        </dependency>
        <!-- More libraries... -->
    </dependencies>
</dependencyManagement>
```

#### 2. Add to Your Service POM

In your service's `pom.xml`, add dependencies without versions:

```xml
<dependencies>
    <!-- Common Libraries -->
    <dependency>
        <groupId>com.yaniq</groupId>
        <artifactId>common-logging</artifactId>
    </dependency>
    
    <dependency>
        <groupId>com.yaniq</groupId>
        <artifactId>common-exceptions</artifactId>
    </dependency>
    
    <dependency>
        <groupId>com.yaniq</groupId>
        <artifactId>common-api</artifactId>
    </dependency>
</dependencies>
```

#### 3. Build and Use

```bash
# Build all libraries
mvn clean install

# Or build specific library
cd libs/common-logging
mvn clean install
```

---

## 💡 Usage Examples

### Complete Service Example

```java
package com.yaniq.service.product;

import com.yaniq.common.logging.CommonLogger;
import com.yaniq.common.exceptions.ResourceNotFoundException;
import com.yaniq.common.api.response.ApiResponse;
import com.yaniq.common.audit.annotation.Audited;

@Service
@RequiredArgsConstructor
public class ProductService {
    
    private final CommonLogger logger = CommonLogger.getLogger(ProductService.class);
    private final ProductRepository productRepository;
    
    @Audited(action = "PRODUCT_VIEW", category = "PRODUCT")
    public ProductDTO getProduct(Long id) {
        logger.debug("Fetching product with id: {}", id);
        
        long startTime = System.currentTimeMillis();
        
        Product product = productRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Product", "id", id));
        
        long duration = System.currentTimeMillis() - startTime;
        logger.performance("getProduct", duration, "ProductId: {}", id);
        
        return productMapper.toDTO(product);
    }
    
    @Audited(action = "PRODUCT_CREATE", category = "PRODUCT")
    public ProductDTO createProduct(CreateProductRequest request) {
        logger.info("Creating product | Name: {} | Category: {}", 
            request.getName(), request.getCategoryId());
        
        try {
            Product product = productMapper.toEntity(request);
            Product saved = productRepository.save(product);
            
            // Publish event
            eventPublisher.publish("product-events", 
                new ProductCreatedEvent(saved.getId(), saved.getName()));
            
            logger.info("Product created successfully | Id: {}", saved.getId());
            return productMapper.toDTO(saved);
            
        } catch (Exception e) {
            logger.error("Failed to create product | Name: {}", 
                request.getName(), e);
            throw e;
        }
    }
}

@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
public class ProductController {
    
    private final ProductService productService;
    private final CommonLogger logger = CommonLogger.getLogger(ProductController.class);
    
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ProductDTO>> getProduct(@PathVariable Long id) {
        ProductDTO product = productService.getProduct(id);
        return ResponseEntity.ok(ApiResponse.success(product));
    }
    
    @GetMapping
    public ResponseEntity<ApiResponse<Page<ProductDTO>>> getProducts(Pageable pageable) {
        Page<ProductDTO> products = productService.findAll(pageable);
        return ResponseEntity.ok(ApiResponse.success(products));
    }
    
    @PostMapping
    public ResponseEntity<ApiResponse<ProductDTO>> createProduct(
            @Valid @RequestBody CreateProductRequest request) {
        ProductDTO product = productService.createProduct(request);
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(ApiResponse.success(product, "Product created successfully"));
    }
}
```

---

## 🎯 Best Practices

### 1. Use Common Logging Everywhere

```java
// ✅ Good: Use CommonLogger
private final CommonLogger logger = CommonLogger.getLogger(MyService.class);

// ❌ Bad: Use SLF4J directly
private static final Logger logger = LoggerFactory.getLogger(MyService.class);
```

### 2. Throw Common Exceptions

```java
// ✅ Good: Use common exceptions
throw new ResourceNotFoundException("User", "id", userId);
throw new BusinessException("INVALID_OPERATION", "Cannot delete active user");

// ❌ Bad: Generic exceptions
throw new RuntimeException("User not found");
throw new Exception("Error");
```

### 3. Return Standard API Responses

```java
// ✅ Good: Consistent response format
return ApiResponse.success(data);
return ApiResponse.error("ERROR_CODE", "Error message");

// ❌ Bad: Inconsistent responses
return ResponseEntity.ok(data);
return Map.of("error", "Something went wrong");
```

### 4. Audit Sensitive Operations

```java
// ✅ Good: Audit important actions
@Audited(action = "USER_DELETE", category = "USER_MANAGEMENT")
public void deleteUser(Long userId) { }

// ❌ Bad: No audit trail
public void deleteUser(Long userId) { }
```

### 5. Use Performance Logging

```java
// ✅ Good: Track performance
long start = System.currentTimeMillis();
// ... operation ...
logger.performance("operation", System.currentTimeMillis() - start, 
    "Details: {}", details);

// ❌ Bad: No performance tracking
// ... operation ...
```

---

## 🔧 Library Development

### Creating a New Library

1. **Create Module Structure**:
```bash
cd libs
mkdir common-newlibrary
cd common-newlibrary
```

2. **Create POM.xml**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project>
    <parent>
        <groupId>com.yaniq</groupId>
        <artifactId>yaniq</artifactId>
        <version>1.0.0</version>
        <relativePath>../../pom.xml</relativePath>
    </parent>
    
    <artifactId>common-newlibrary</artifactId>
    <name>Common New Library</name>
    <description>Description of new library</description>
</project>
```

3. **Add to Parent POM**:
```xml
<modules>
    <module>libs/common-newlibrary</module>
</modules>
```

4. **Create Documentation**:
- Add README.md in library folder
- Add usage examples
- Document API reference

---

## 📚 Library Documentation

### Complete Documentation Links

| Library | API Docs | Usage Guide | Best Practices |
|---------|----------|-------------|----------------|
| **Common Logging** | [API Reference](./logging/common-logging-api.md) | [Usage Guide](./logging/common-logging-usage.md) | [Best Practices](./logging/common-logging-best-practices.md) |
| **Common Audit** | Coming Soon | Coming Soon | Coming Soon |
| **Common Exceptions** | Coming Soon | Coming Soon | Coming Soon |
| **Common Messaging** | Coming Soon | Coming Soon | Coming Soon |
| **Common API** | Coming Soon | Coming Soon | Coming Soon |

---

## 🤝 Contributing

### Adding Features to Libraries

1. **Discuss First**: Open an issue to discuss the feature
2. **Follow Standards**: Use existing code style
3. **Add Tests**: Minimum 80% coverage
4. **Document**: Update documentation
5. **Version Bump**: Follow semantic versioning

### Testing Libraries

```bash
# Test specific library
cd libs/common-logging
mvn test

# Test all libraries
cd libs
mvn test

# With coverage
mvn test jacoco:report
```

### Publishing Updates

```bash
# Build and install locally
mvn clean install

# Services will automatically use updated version
```

---

## 📊 Library Status Dashboard

| Library | Version | Coverage | Status | Last Updated |
|---------|---------|----------|--------|--------------|
| common-logging | 2.0 | 85% | ✅ Stable | 2025-10-14 |
| common-audit | 1.0 | 75% | ✅ Stable | 2025-10-10 |
| common-exceptions | 1.0 | 80% | ✅ Stable | 2025-10-08 |
| common-messaging | 1.0 | 70% | ✅ Stable | 2025-10-05 |
| common-api | 1.0 | 78% | ✅ Stable | 2025-10-03 |
| common-security | 0.9 | 60% | 🚧 Beta | 2025-09-30 |
| common-cache | 0.8 | 55% | 🚧 Alpha | 2025-09-28 |
| common-validation | 0.7 | 50% | 🚧 Alpha | 2025-09-25 |
| common-utils | 0.6 | 45% | 🚧 Alpha | 2025-09-20 |
| common-config | 0.5 | 40% | 🚧 Alpha | 2025-09-15 |

---

## 🔗 Quick Links

- 📖 [Main Documentation](../README.md)
- 🏗️ [Architecture Guide](../ARCHITECTURE.md)
- 🚀 [Getting Started](../GETTING_STARTED.md)
- 🤝 [Contributing Guide](../CONTRIBUTING.md)

---

## 📞 Support

For library-specific issues:
- 🐛 [Report Issues](https://github.com/yaniq/yaniq-monorepo/issues)
- 💬 [Ask Questions](https://github.com/yaniq/yaniq-monorepo/discussions)
- 📧 Email: danukajihansanath0408@gmail.com

---

<div align="center">

**YaniQ Shared Libraries** | **Building Better Microservices Together**

[⬆ Back to Top](#-yaniq-shared-libraries) | [📖 Main Documentation](../README.md)

</div>

