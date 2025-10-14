# YaniQ Common Logging Library

## Table of Contents
1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [Configuration](#configuration)
4. [Usage Examples](#usage-examples)
5. [Logging Strategies](#logging-strategies)
6. [Security & Audit Logging](#security--audit-logging)
7. [Performance Monitoring](#performance-monitoring)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)
10. [API Reference](#api-reference)

## Overview

The YaniQ Common Logging Library provides a comprehensive, structured logging solution designed for microservices architecture. It supports multiple output formats, asynchronous processing, and specialized logging for security, audit, and performance monitoring.

### Key Features

- **Structured Logging**: SLF4J-style placeholder support with `{}`
- **Multiple Strategies**: Console, ELK Stack, File, and Structured JSON outputs
- **Asynchronous Processing**: High-performance non-blocking logging
- **Security-First**: Built-in security event and audit trail logging
- **Correlation Tracking**: Request correlation IDs for distributed tracing
- **Performance Monitoring**: Built-in performance metrics and timing
- **Enterprise Ready**: Compliance, audit trails, and production monitoring

## Quick Start

### 1. Basic Usage

```java
import com.yaniq.common_logging.CommonLogger;

public class MyService {
    private final CommonLogger logger = CommonLogger.getLogger();
    
    public void doSomething() {
        logger.info("Service operation started");
        logger.info("Processing user: {} with ID: {}", username, userId);
        logger.info("Operation completed successfully");
    }
}
```

### 2. Class-Specific Logger

```java
public class AuthenticationService {
    private final CommonLogger logger = CommonLogger.getLogger(AuthenticationService.class);
    
    public void authenticate(String email) {
        logger.info("Authentication attempt for: {}", maskEmail(email));
    }
}
```

### 3. Named Logger

```java
public class PaymentProcessor {
    private final CommonLogger logger = CommonLogger.getLogger("payment-processor");
    
    public void processPayment(String paymentId) {
        logger.info("Processing payment: {}", paymentId);
    }
}
```

## Configuration

### Environment Variables

Set the `LOG_MODE` environment variable to choose your logging strategy:

```bash
# Console output (default)
export LOG_MODE=CONSOLE

# ELK Stack compatible JSON logs
export LOG_MODE=ELK

# File-based logging with daily rotation
export LOG_MODE=FILE

# Pure structured JSON logs
export LOG_MODE=STRUCTURED
```

### Additional Configuration

```bash
# Service name for ELK logs
export service.name=auth-service

# Log directory for file logging
export yaniq.log.dir=/var/logs/yaniq

# Enable debug logging
export yaniq.log.debug=true

# Enable trace logging
export yaniq.log.trace=true
```

## Usage Examples

### Basic Logging Levels

```java
private final CommonLogger logger = CommonLogger.getLogger();

// Different log levels
logger.trace("Detailed execution trace");
logger.debug("Debug information");
logger.info("General information");
logger.warn("Warning message");
logger.error("Error occurred");
logger.fatal("Critical system failure");
```

### Structured Logging with Placeholders

```java
// SLF4J-style placeholders
logger.info("User {} logged in from IP {} at {}", 
    userId, clientIP, LocalDateTime.now());

// Complex structured data
logger.info("AUTH_SUCCESS | CorrelationId: {} | UserId: {} | Duration: {}ms | Role: {}", 
    correlationId, userId, duration, userRole);
```

### Exception Logging

```java
try {
    riskyOperation();
} catch (Exception e) {
    logger.error("Operation failed for user: {}", userId, e);
    // or
    logger.error("Database connection failed: {}", e.getMessage(), e);
}
```

### Conditional Logging

```java
if (logger.isDebugEnabled()) {
    String expensiveDebugInfo = generateDebugInfo();
    logger.debug("Debug info: {}", expensiveDebugInfo);
}
```

## Logging Strategies

### 1. Console Strategy (Default)

Outputs to standard console using SLF4J loggers.

```java
// Output example:
2025-10-14 10:30:15.123 INFO  [auth-service] User john.doe@example.com logged in successfully
```

### 2. ELK Strategy

Produces ELK Stack compatible JSON logs with standardized fields.

```json
{
  "@timestamp": "2025-10-14T10:30:15.123",
  "@version": "1",
  "level": "INFO",
  "logger_name": "AuthenticationService",
  "message": "User login successful",
  "service_name": "auth-service",
  "thread_name": "http-nio-8080-exec-1",
  "host": "auth-server-01",
  "tags": ["yaniq", "auth-service", "info"]
}
```

### 3. File Strategy

Writes logs to daily rotated files with structured format.

```
[2025-10-14 10:30:15.123] [INFO] [http-nio-8080-exec-1] [AuthenticationService] User login successful
```

Files are stored as: `{logger-name}-{YYYY-MM-DD}.log`

### 4. Structured Strategy

Pure JSON structured logs for custom processing.

```json
{
  "timestamp": "2025-10-14T10:30:15.123",
  "level": "INFO",
  "logger": "AuthenticationService",
  "message": "User login successful",
  "thread": "http-nio-8080-exec-1"
}
```

## Security & Audit Logging

### Security Event Logging

```java
// Security events with correlation tracking
logger.security("LOGIN_ATTEMPT", correlationId, 
    "User: {} | IP: {} | UserAgent: {}", maskedEmail, clientIP, userAgent);

logger.security("PERMISSION_DENIED", correlationId,
    "User: {} | Resource: {} | Action: {}", userId, resource, action);
```

### Audit Trail Logging

```java
// Compliance and audit logging
logger.audit("USER_CREATE", adminId, 
    "Created user: {} | Role: {} | Department: {}", newUserId, role, department);

logger.audit("DATA_ACCESS", userId,
    "Accessed sensitive data: {} | Reason: {}", dataType, accessReason);
```

### Authentication Service Example

```java
@Service
public class AuthenticationService {
    private final CommonLogger logger = CommonLogger.getLogger();
    
    public LoginResponse authenticate(LoginRequest request) {
        String correlationId = UUID.randomUUID().toString().substring(0, 8);
        String maskedEmail = maskEmail(request.getEmail());
        long startTime = System.currentTimeMillis();
        
        logger.info("AUTH_START | CorrelationId: {} | Email: {} | Timestamp: {}", 
            correlationId, maskedEmail, LocalDateTime.now());
            
        try {
            // Authentication logic...
            
            long duration = System.currentTimeMillis() - startTime;
            logger.info("AUTH_SUCCESS | CorrelationId: {} | UserId: {} | Duration: {}ms", 
                correlationId, user.getId(), duration);
                
            logger.security("LOGIN_SUCCESS", correlationId,
                "User: {} | Role: {} | Duration: {}ms", maskedEmail, user.getRole(), duration);
                
            return response;
            
        } catch (Exception e) {
            logger.error("AUTH_FAILURE | CorrelationId: {} | Error: {}", 
                correlationId, e.getMessage(), e);
                
            logger.security("LOGIN_FAILURE", correlationId,
                "User: {} | Error: {}", maskedEmail, e.getMessage());
                
            throw e;
        }
    }
}
```

## Performance Monitoring

### Performance Logging

```java
// Track operation performance
logger.performance("user_creation", duration, 
    "Steps: validation({})ms, save({})ms, profile({})ms", 
    validationTime, saveTime, profileTime);

logger.performance("database_query", queryTime,
    "Query: {} | Records: {} | Cache: {}", queryType, recordCount, cacheHit);
```

### Metrics Logging

```java
// Application metrics
logger.metric("active_sessions", sessionCount, "service:auth", "region:us-east");
logger.metric("login_attempts", attemptCount, "outcome:success", "method:oauth");
logger.metric("response_time", avgResponseTime, "endpoint:/api/login", "status:200");
```

### Performance Monitoring Example

```java
@Service
public class UserService {
    private final CommonLogger logger = CommonLogger.getLogger();
    
    public UserResponse createUser(UserCreateRequest request) {
        long startTime = System.currentTimeMillis();
        String correlationId = generateCorrelationId();
        
        logger.info("USER_CREATE_START | CorrelationId: {} | Email: {}", 
            correlationId, maskEmail(request.getEmail()));
        
        try {
            // Step 1: Validation
            long validationStart = System.currentTimeMillis();
            validateRequest(request);
            long validationTime = System.currentTimeMillis() - validationStart;
            
            // Step 2: Save user
            long saveStart = System.currentTimeMillis();
            User user = saveUser(request);
            long saveTime = System.currentTimeMillis() - saveStart;
            
            // Step 3: Create profile
            long profileStart = System.currentTimeMillis();
            createProfile(user, request);
            long profileTime = System.currentTimeMillis() - profileStart;
            
            long totalTime = System.currentTimeMillis() - startTime;
            
            // Performance logging
            logger.performance("user_creation", totalTime,
                "Validation: {}ms | Save: {}ms | Profile: {}ms | Total: {}ms",
                validationTime, saveTime, profileTime, totalTime);
            
            // Metrics
            logger.metric("user_creation_time", totalTime, "outcome:success");
            logger.metric("user_creation_steps", 3, "validation", "save", "profile");
            
            return UserResponse.fromUser(user);
            
        } catch (Exception e) {
            long errorTime = System.currentTimeMillis() - startTime;
            logger.error("USER_CREATE_FAILED | CorrelationId: {} | Duration: {}ms | Error: {}", 
                correlationId, errorTime, e.getMessage(), e);
            
            logger.metric("user_creation_time", errorTime, "outcome:failure");
            throw e;
        }
    }
}
```

## Best Practices

### 1. Use Correlation IDs

Always include correlation IDs for request tracking:

```java
String correlationId = UUID.randomUUID().toString().substring(0, 8);
logger.info("OPERATION_START | CorrelationId: {} | User: {}", correlationId, userId);
```

### 2. Mask Sensitive Information

Never log sensitive data in plain text:

```java
// Good
logger.info("Authentication attempt for: {}", maskEmail(email));

// Bad
logger.info("Authentication attempt for: {}", email);
```

### 3. Use Structured Logging

Prefer structured key-value format:

```java
// Good
logger.info("AUTH_SUCCESS | UserId: {} | Duration: {}ms | Role: {}", 
    userId, duration, role);

// Less ideal
logger.info("User " + userId + " authenticated successfully in " + duration + "ms");
```

### 4. Log at Appropriate Levels

- **TRACE**: Very detailed debugging information
- **DEBUG**: Debugging information for development
- **INFO**: General application flow information
- **WARN**: Potentially harmful situations
- **ERROR**: Error events that allow application to continue
- **FATAL**: Critical errors that may cause application termination

### 5. Include Context Information

Always provide sufficient context:

```java
logger.error("Database operation failed | Table: {} | Operation: {} | User: {} | Error: {}", 
    tableName, operation, userId, e.getMessage(), e);
```

### 6. Use Performance Guards

For expensive operations:

```java
if (logger.isDebugEnabled()) {
    String expensiveData = generateComplexDebugInfo();
    logger.debug("Complex debug data: {}", expensiveData);
}
```

## Troubleshooting

### Common Issues

1. **Logs not appearing**
   - Check LOG_MODE environment variable
   - Verify log level configuration
   - Check file permissions for FILE strategy

2. **Performance issues**
   - Logger uses asynchronous processing
   - Consider reducing log level in production
   - Monitor thread pool usage

3. **JSON parsing errors in ELK**
   - Verify Jackson dependency is available
   - Check ELK configuration for proper field mapping

### Debug Configuration

```bash
# Enable debug logging
export yaniq.log.debug=true

# Enable trace logging
export yaniq.log.trace=true

# Set custom log directory
export yaniq.log.dir=/custom/log/path
```

## API Reference

### CommonLogger Methods

#### Basic Logging
- `info(String message)`
- `info(String format, Object... args)`
- `info(String message, Throwable throwable)`
- `warn(String message)`
- `warn(String format, Object... args)`
- `warn(String message, Throwable throwable)`
- `error(String message)`
- `error(String format, Object... args)`
- `error(String message, Throwable throwable)`
- `debug(String message)`
- `debug(String format, Object... args)`
- `debug(String message, Throwable throwable)`
- `trace(String message)`
- `trace(String format, Object... args)`
- `trace(String message, Throwable throwable)`
- `fatal(String message)`
- `fatal(String format, Object... args)`
- `fatal(String message, Throwable throwable)`

#### Specialized Logging
- `security(String eventType, String correlationId, String format, Object... args)`
- `audit(String eventType, String userId, String format, Object... args)`
- `performance(String operation, long duration, String format, Object... args)`
- `metric(String metricName, Object value, String... tags)`

#### Level Checking
- `isInfoEnabled()`
- `isWarnEnabled()`
- `isErrorEnabled()`
- `isDebugEnabled()`
- `isTraceEnabled()`

#### Utility Methods
- `structured(Object... keyValuePairs)` - Creates structured key-value log entries
- `flush()` - Flushes pending log messages

### Factory Methods
- `CommonLogger.getLogger()` - Get default logger
- `CommonLogger.getLogger(Class<?> clazz)` - Get class-specific logger
- `CommonLogger.getLogger(String name)` - Get named logger

---

## Support

For issues, questions, or contributions, please contact the YaniQ development team or refer to the project repository.

**Version**: 2.0  
**Last Updated**: October 14, 2025
