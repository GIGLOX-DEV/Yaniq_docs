# CommonLogger Migration Guide

## Upgrading from Version 1.x to 2.0

This guide helps you migrate from the basic CommonLogger v1.x to the enhanced v2.0 with structured logging support.

## What's New in Version 2.0

### ✅ New Features
- **Structured Logging**: SLF4J-style `{}` placeholder support
- **Multiple Log Levels**: TRACE, DEBUG, INFO, WARN, ERROR, FATAL
- **Specialized Methods**: Security, audit, performance, and metrics logging
- **Multiple Strategies**: ELK, File, Structured JSON, Console
- **Enhanced Error Handling**: Better exception support with throwables
- **Level Checking**: Performance optimization with `isXxxEnabled()` methods
- **Named Loggers**: Class-specific and custom-named logger support

### 🔧 Breaking Changes
- Method signatures updated to support placeholders
- New constructor patterns for strategies
- Enhanced LogStrategy interface

## Migration Steps

### Step 1: Update Basic Logging Calls

#### Before (v1.x)
```java
logger.info("User authenticated successfully");
logger.info("User " + userId + " authenticated in " + duration + "ms");
```

#### After (v2.0)
```java
logger.info("User authenticated successfully");
logger.info("User {} authenticated in {}ms", userId, duration);
```

### Step 2: Replace String Concatenation

#### Before (v1.x)
```java
logger.error("Database operation failed for user " + userId + " with error: " + error, exception);
```

#### After (v2.0)
```java
logger.error("Database operation failed for user {} with error: {}", userId, error, exception);
```

### Step 3: Update Custom LogStrategy Implementations

#### Before (v1.x)
```java
public class CustomLogStrategy implements LogStrategy {
    public void info(String message) { /* implementation */ }
    public void warn(String message) { /* implementation */ }
    public void error(String message, Throwable throwable) { /* implementation */ }
    public void debug(String message) { /* implementation */ }
}
```

#### After (v2.0)
```java
public class CustomLogStrategy implements LogStrategy {
    // Basic methods with throwable support
    public void info(String message) { /* implementation */ }
    public void info(String message, Throwable throwable) { /* implementation */ }
    public void warn(String message) { /* implementation */ }
    public void warn(String message, Throwable throwable) { /* implementation */ }
    public void error(String message) { /* implementation */ }
    public void error(String message, Throwable throwable) { /* implementation */ }
    public void debug(String message) { /* implementation */ }
    public void debug(String message, Throwable throwable) { /* implementation */ }
    
    // New methods to implement
    public void trace(String message) { /* implementation */ }
    public void trace(String message, Throwable throwable) { /* implementation */ }
    public void fatal(String message) { /* implementation */ }
    public void fatal(String message, Throwable throwable) { /* implementation */ }
    
    // Level checking methods
    public boolean isInfoEnabled() { return true; }
    public boolean isWarnEnabled() { return true; }
    public boolean isErrorEnabled() { return true; }
    public boolean isDebugEnabled() { return true; }
    public boolean isTraceEnabled() { return true; }
}
```

### Step 4: Add Constructor Support for Named Loggers

#### Before (v1.x)
```java
public class ELKLogStrategy implements LogStrategy {
    private final Logger logger = LoggerFactory.getLogger(ELKLogStrategy.class);
    
    public ELKLogStrategy() {
        // Simple constructor
    }
}
```

#### After (v2.0)
```java
public class ELKLogStrategy implements LogStrategy {
    private final Logger logger;
    private final String loggerName;
    
    public ELKLogStrategy() {
        this("ELKLogger");
    }
    
    public ELKLogStrategy(String loggerName) {
        this.loggerName = loggerName != null ? loggerName : "ELKLogger";
        this.logger = LoggerFactory.getLogger(this.loggerName);
    }
}
```

## Code Migration Examples

### Authentication Service Migration

#### Before (v1.x)
```java
@Service
public class AuthenticationService {
    private final CommonLogger logger = CommonLogger.getLogger();
    
    public LoginResponse authenticate(LoginRequest request) {
        logger.info("Authentication attempt started");
        
        try {
            User user = findUser(request.getEmail());
            logger.info("User found: " + user.getId());
            
            if (validatePassword(request.getPassword(), user.getPassword())) {
                logger.info("Authentication successful for user: " + user.getId());
                return generateResponse(user);
            } else {
                logger.warn("Invalid password for user: " + user.getId());
                throw new InvalidCredentialsException();
            }
        } catch (Exception e) {
            logger.error("Authentication failed: " + e.getMessage(), e);
            throw e;
        }
    }
}
```

#### After (v2.0)
```java
@Service
public class AuthenticationService {
    private final CommonLogger logger = CommonLogger.getLogger(AuthenticationService.class);
    
    public LoginResponse authenticate(LoginRequest request) {
        String correlationId = UUID.randomUUID().toString().substring(0, 8);
        String maskedEmail = maskEmail(request.getEmail());
        long startTime = System.currentTimeMillis();
        
        logger.info("AUTH_START | CorrelationId: {} | Email: {} | Timestamp: {}", 
            correlationId, maskedEmail, LocalDateTime.now());
        
        try {
            User user = findUser(request.getEmail());
            logger.debug("AUTH_USER_FOUND | CorrelationId: {} | UserId: {}", correlationId, user.getId());
            
            if (validatePassword(request.getPassword(), user.getPassword())) {
                long duration = System.currentTimeMillis() - startTime;
                logger.info("AUTH_SUCCESS | CorrelationId: {} | UserId: {} | Duration: {}ms", 
                    correlationId, user.getId(), duration);
                
                logger.security("LOGIN_SUCCESS", correlationId, 
                    "User: {} | Duration: {}ms", maskedEmail, duration);
                
                return generateResponse(user);
            } else {
                logger.warn("AUTH_INVALID_PASSWORD | CorrelationId: {} | UserId: {}", 
                    correlationId, user.getId());
                
                logger.security("LOGIN_FAILURE", correlationId, 
                    "User: {} | Reason: Invalid password", maskedEmail);
                
                throw new InvalidCredentialsException();
            }
        } catch (Exception e) {
            long duration = System.currentTimeMillis() - startTime;
            logger.error("AUTH_FAILED | CorrelationId: {} | Duration: {}ms | Error: {}", 
                correlationId, duration, e.getMessage(), e);
            
            logger.security("LOGIN_ERROR", correlationId, 
                "User: {} | Error: {}", maskedEmail, e.getMessage());
            
            throw e;
        }
    }
}
```

### Validation Service Migration

#### Before (v1.x)
```java
@Service
public class ValidationService {
    private final CommonLogger logger = CommonLogger.getLogger();
    
    public void validateEmail(String email) {
        logger.debug("Validating email");
        
        if (email == null || email.trim().isEmpty()) {
            logger.warn("Email validation failed: null or empty");
            throw new ValidationException("Email is required");
        }
        
        if (!isValidFormat(email)) {
            logger.warn("Email validation failed: invalid format for " + email);
            throw new ValidationException("Invalid email format");
        }
        
        logger.debug("Email validation passed");
    }
}
```

#### After (v2.0)
```java
@Service
public class ValidationService {
    private final CommonLogger logger = CommonLogger.getLogger(ValidationService.class);
    
    public void validateEmail(String email) {
        logger.debug("Validating email format");
        
        if (email == null || email.trim().isEmpty()) {
            logger.warn("VALIDATION_FAILED | Field: email | Reason: null or empty");
            throw ExceptionFactory.create(ErrorCatalog.VALIDATION_FAILED, "Email is required");
        }
        
        String trimmedEmail = email.trim().toLowerCase();
        
        if (trimmedEmail.length() > 254) {
            logger.warn("VALIDATION_FAILED | Field: email | Reason: too long | Length: {}", 
                trimmedEmail.length());
            throw ExceptionFactory.create(ErrorCatalog.VALIDATION_FAILED,
                "Email address is too long (maximum 254 characters)");
        }
        
        if (!EMAIL_PATTERN.matcher(trimmedEmail).matches()) {
            logger.warn("VALIDATION_FAILED | Field: email | Reason: invalid format | Email: {}", 
                maskEmail(trimmedEmail));
            throw ExceptionFactory.create(ErrorCatalog.VALIDATION_FAILED, "Invalid email format");
        }
        
        if (isDisposableEmailDomain(trimmedEmail)) {
            logger.warn("VALIDATION_FAILED | Field: email | Reason: disposable domain | Email: {}", 
                maskEmail(trimmedEmail));
            throw ExceptionFactory.create(ErrorCatalog.VALIDATION_FAILED,
                "Disposable email addresses are not allowed");
        }
        
        logger.debug("Email validation passed for: {}", maskEmail(trimmedEmail));
    }
}
```

## Configuration Migration

### Environment Variables

#### Before (v1.x)
```bash
export LOG_MODE=CONSOLE  # Only CONSOLE and ELK supported
```

#### After (v2.0)
```bash
export LOG_MODE=CONSOLE     # CONSOLE, ELK, FILE, STRUCTURED supported
export service.name=auth-service
export service.version=1.0.0
export yaniq.log.debug=true
export yaniq.log.dir=/var/logs/yaniq
```

### Spring Boot Configuration

#### Before (v1.x)
```yaml
# Limited configuration
logging:
  level:
    com.yaniq: DEBUG
```

#### After (v2.0)
```yaml
yaniq:
  logging:
    mode: ${LOG_MODE:CONSOLE}
    debug: ${yaniq.log.debug:false}
    trace: ${yaniq.log.trace:false}
    directory: ${yaniq.log.dir:logs}

service:
  name: ${service.name:yaniq-service}
  version: ${service.version:1.0.0}
  environment: ${service.environment:development}
```

## Testing Migration

### Unit Test Updates

#### Before (v1.x)
```java
@Test
void shouldLogUserCreation() {
    userService.createUser(request);
    
    // Basic verification
    verify(logger).info("User creation started");
    verify(logger).info(contains("User created"));
}
```

#### After (v2.0)
```java
@Test
void shouldLogUserCreation() {
    userService.createUser(request);
    
    // Structured logging verification
    verify(logger).info(eq("USER_CREATE_START | CorrelationId: {} | Email: {}"), 
        any(String.class), eq("te***@example.com"));
    verify(logger).info(eq("USER_CREATE_SUCCESS | CorrelationId: {} | UserId: {} | Duration: {}ms"), 
        any(String.class), any(Long.class), any(Long.class));
    verify(logger).metric(eq("user_creation_time"), any(Long.class), any(String.class));
}
```

## Performance Considerations

### Memory Usage
- **v1.x**: String concatenation creates temporary objects
- **v2.0**: Placeholder replacement is more memory efficient

### CPU Usage
- **v1.x**: String operations on calling thread
- **v2.0**: Asynchronous processing reduces impact on main threads

### I/O Performance
- **v1.x**: Synchronous logging operations
- **v2.0**: Buffered asynchronous operations

## Common Migration Issues

### Issue 1: Placeholder Mismatch
```java
// Wrong - {} count doesn't match arguments
logger.info("User {} created with role {}", userId); // Missing second argument

// Correct
logger.info("User {} created with role {}", userId, userRole);
```

### Issue 2: Exception Parameter Position
```java
// Wrong - Exception should be last parameter
logger.error("Error: {} for user {}", exception, userId, otherData);

// Correct
logger.error("Error: {} for user {}", exception.getMessage(), userId, exception);
```

### Issue 3: Strategy Constructor Updates
```java
// Update custom strategies to support named loggers
public CustomStrategy(String loggerName) {
    this.loggerName = loggerName != null ? loggerName : "CustomLogger";
}
```

## Rollback Plan

If you need to rollback to v1.x:

1. **Revert method calls**: Replace placeholder syntax with string concatenation
2. **Remove new method calls**: Remove security(), audit(), performance(), metric() calls
3. **Update strategy implementations**: Remove new interface methods
4. **Revert configuration**: Simplify environment variables

## Verification Steps

After migration, verify:

1. **Logging Output**: Check that logs appear correctly in chosen format
2. **Performance**: Monitor application performance impact
3. **Error Handling**: Verify exceptions are logged properly with stack traces
4. **Configuration**: Test different LOG_MODE values work correctly
5. **Integration**: Ensure monitoring and alerting systems work with new log format

---

**Migration Support**: Contact the development team for assistance with complex migration scenarios or custom strategy implementations.
