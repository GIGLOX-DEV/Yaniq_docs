# CommonLogger Best Practices Guide

## Security Best Practices

### 1. Data Masking and Privacy Protection

Always mask sensitive information in logs to protect user privacy and comply with regulations like GDPR and CCPA.

#### Email Masking
```java
private String maskEmail(String email) {
    if (email == null || email.length() < 3) return "***";
    int atIndex = email.indexOf('@');
    if (atIndex > 0) {
        String localPart = email.substring(0, atIndex);
        String domain = email.substring(atIndex);
        if (localPart.length() <= 2) {
            return "**" + domain;
        } else {
            return localPart.substring(0, 2) + "***" + domain;
        }
    }
    return email.substring(0, 2) + "***";
}

// Usage
logger.info("User login attempt: {}", maskEmail(email));
// Output: User login attempt: jo***@example.com
```

#### Phone Number Masking
```java
private String maskPhone(String phone) {
    if (phone == null || phone.length() < 4) return "***";
    return "***" + phone.substring(phone.length() - 4);
}

// Usage
logger.info("SMS sent to: {}", maskPhone(phoneNumber));
// Output: SMS sent to: ***1234
```

#### Credit Card Masking
```java
private String maskCreditCard(String cardNumber) {
    if (cardNumber == null || cardNumber.length() < 8) return "****";
    return "****-****-****-" + cardNumber.substring(cardNumber.length() - 4);
}
```

### 2. Never Log These Items

❌ **Never log these sensitive items:**
- Passwords (plain text or hashed)
- Credit card numbers
- Social Security Numbers
- API keys or tokens
- Session IDs
- Personal identification numbers

```java
// BAD - Never do this
logger.info("User {} logged in with password {}", username, password);
logger.info("Processing payment with card {}", creditCardNumber);

// GOOD - Log safely
logger.info("User {} authentication successful", maskEmail(username));
logger.info("Payment processed for card ending in {}", 
    creditCardNumber.substring(creditCardNumber.length() - 4));
```

## Performance Best Practices

### 1. Use Conditional Logging for Expensive Operations

```java
// Expensive operation - only execute if debug is enabled
if (logger.isDebugEnabled()) {
    String expensiveDebugData = generateComplexDebugInfo();
    logger.debug("Complex operation details: {}", expensiveDebugData);
}

// Efficient - log level check is built into the library
logger.debug("Simple debug message: {}", simpleValue);
```

### 2. Leverage Asynchronous Logging

The CommonLogger automatically uses asynchronous processing, but you can optimize further:

```java
// The logger handles async processing automatically
logger.info("This message is processed asynchronously");

// For critical operations, you can flush if needed
logger.error("Critical error occurred: {}", errorDetails);
logger.flush(); // Ensures immediate processing
```

### 3. Batch Related Log Entries

```java
// Instead of multiple separate calls
logger.info("Step 1 completed");
logger.info("Step 2 completed");
logger.info("Step 3 completed");

// Use structured logging for related operations
logger.info("Process completed | Step1: {}ms | Step2: {}ms | Step3: {}ms | Total: {}ms",
    step1Time, step2Time, step3Time, totalTime);
```

## Correlation and Tracing Best Practices

### 1. Always Use Correlation IDs

```java
@Service
public class OrderService {
    private final CommonLogger logger = CommonLogger.getLogger();
    
    public OrderResponse processOrder(OrderRequest request) {
        // Generate correlation ID for request tracking
        String correlationId = UUID.randomUUID().toString().substring(0, 8);
        
        logger.info("ORDER_START | CorrelationId: {} | CustomerId: {} | Items: {}", 
            correlationId, request.getCustomerId(), request.getItems().size());
        
        try {
            // All subsequent operations use the same correlation ID
            validateOrder(correlationId, request);
            PaymentResponse payment = processPayment(correlationId, request);
            InventoryResponse inventory = reserveInventory(correlationId, request);
            
            logger.info("ORDER_SUCCESS | CorrelationId: {} | OrderId: {} | Duration: {}ms", 
                correlationId, order.getId(), duration);
                
            return order;
            
        } catch (Exception e) {
            logger.error("ORDER_FAILED | CorrelationId: {} | Error: {}", 
                correlationId, e.getMessage(), e);
            throw e;
        }
    }
    
    private void validateOrder(String correlationId, OrderRequest request) {
        logger.debug("ORDER_VALIDATION | CorrelationId: {} | Status: STARTING", correlationId);
        // Validation logic...
        logger.info("ORDER_VALIDATION | CorrelationId: {} | Status: SUCCESS", correlationId);
    }
}
```

### 2. Thread Context Preservation

For passing correlation IDs across threads:

```java
@Component
public class CorrelationContext {
    private static final ThreadLocal<String> correlationId = new ThreadLocal<>();
    
    public static void set(String id) {
        correlationId.set(id);
    }
    
    public static String get() {
        return correlationId.get();
    }
    
    public static void clear() {
        correlationId.remove();
    }
}

// Usage in service
public void processAsync(OrderRequest request) {
    String correlationId = CorrelationContext.get();
    
    CompletableFuture.runAsync(() -> {
        CorrelationContext.set(correlationId); // Preserve context
        logger.info("ASYNC_PROCESSING | CorrelationId: {} | Status: STARTED", correlationId);
        // Process...
        CorrelationContext.clear(); // Clean up
    });
}
```

## Error Handling Best Practices

### 1. Structured Error Logging

```java
try {
    performDatabaseOperation();
} catch (SQLException e) {
    logger.error("DATABASE_ERROR | Operation: {} | Table: {} | SQLState: {} | ErrorCode: {} | Message: {}", 
        operation, tableName, e.getSQLState(), e.getErrorCode(), e.getMessage(), e);
} catch (ValidationException e) {
    logger.warn("VALIDATION_ERROR | Field: {} | Value: {} | Rule: {} | Message: {}", 
        e.getField(), maskSensitiveValue(e.getValue()), e.getRule(), e.getMessage());
} catch (Exception e) {
    logger.error("UNEXPECTED_ERROR | Operation: {} | Type: {} | Message: {}", 
        operation, e.getClass().getSimpleName(), e.getMessage(), e);
}
```

### 2. Error Context Preservation

```java
public UserResponse createUser(UserCreateRequest request) {
    String correlationId = generateCorrelationId();
    
    try {
        logger.info("USER_CREATE_START | CorrelationId: {} | Email: {}", 
            correlationId, maskEmail(request.getEmail()));
        
        // Step-by-step logging with context
        logger.debug("USER_CREATE_STEP | CorrelationId: {} | Step: VALIDATION | Status: STARTING", 
            correlationId);
        
        validateUser(request);
        
        logger.debug("USER_CREATE_STEP | CorrelationId: {} | Step: VALIDATION | Status: SUCCESS", 
            correlationId);
        
        // Continue with other steps...
        
    } catch (ValidationException e) {
        logger.error("USER_CREATE_FAILED | CorrelationId: {} | Step: VALIDATION | Field: {} | Error: {}", 
            correlationId, e.getField(), e.getMessage());
        throw e;
    } catch (DatabaseException e) {
        logger.error("USER_CREATE_FAILED | CorrelationId: {} | Step: DATABASE | Table: {} | Error: {}", 
            correlationId, e.getTable(), e.getMessage(), e);
        throw e;
    }
}
```

## Monitoring and Observability Best Practices

### 1. Application Metrics Logging

```java
@Service
public class MetricsService {
    private final CommonLogger logger = CommonLogger.getLogger();
    
    public void recordBusinessMetric(String operation, long duration, boolean success) {
        // Record performance metrics
        logger.performance(operation, duration, "Success: {} | Timestamp: {}", 
            success, LocalDateTime.now());
        
        // Record business metrics
        logger.metric("business_operation_count", 1, 
            "operation:" + operation, "outcome:" + (success ? "success" : "failure"));
        
        logger.metric("business_operation_duration", duration,
            "operation:" + operation, "unit:milliseconds");
    }
    
    @Scheduled(fixedRate = 60000) // Every minute
    public void recordSystemMetrics() {
        Runtime runtime = Runtime.getRuntime();
        long totalMemory = runtime.totalMemory();
        long freeMemory = runtime.freeMemory();
        long usedMemory = totalMemory - freeMemory;
        
        logger.metric("jvm_memory_used", usedMemory, "unit:bytes");
        logger.metric("jvm_memory_free", freeMemory, "unit:bytes");
        logger.metric("jvm_memory_total", totalMemory, "unit:bytes");
    }
}
```

### 2. Health Check Logging

```java
@Component
public class HealthCheckLogger {
    private final CommonLogger logger = CommonLogger.getLogger();
    
    @EventListener
    public void handleHealthCheck(HealthCheckEvent event) {
        if (event.isHealthy()) {
            logger.info("HEALTH_CHECK | Service: {} | Status: HEALTHY | ResponseTime: {}ms", 
                event.getServiceName(), event.getResponseTime());
        } else {
            logger.warn("HEALTH_CHECK | Service: {} | Status: UNHEALTHY | Error: {} | ResponseTime: {}ms", 
                event.getServiceName(), event.getError(), event.getResponseTime());
        }
        
        // Record health metrics
        logger.metric("service_health", event.isHealthy() ? 1 : 0, 
            "service:" + event.getServiceName());
    }
}
```

## Testing Best Practices

### 1. Test Logging in Unit Tests

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    
    @Mock
    private CommonLogger logger;
    
    @InjectMocks
    private UserService userService;
    
    @Test
    void shouldLogUserCreationSuccess() {
        // Given
        UserCreateRequest request = new UserCreateRequest();
        request.setEmail("test@example.com");
        
        // When
        userService.createUser(request);
        
        // Then
        verify(logger).info(contains("USER_CREATE_START"), any(), eq("te***@example.com"));
        verify(logger).info(contains("USER_CREATE_SUCCESS"), any(), any());
    }
    
    @Test
    void shouldLogUserCreationFailure() {
        // Given
        UserCreateRequest request = new UserCreateRequest();
        when(userRepository.save(any())).thenThrow(new DatabaseException("Connection failed"));
        
        // When & Then
        assertThrows(DatabaseException.class, () -> userService.createUser(request));
        verify(logger).error(contains("USER_CREATE_FAILED"), any(), any(), any(Exception.class));
    }
}
```

### 2. Integration Test Logging

```java
@SpringBootTest
@TestMethodOrder(OrderAnnotation.class)
class AuthenticationIntegrationTest {
    
    @Autowired
    private CommonLogger logger;
    
    @Test
    @Order(1)
    void shouldLogCompleteAuthenticationFlow() {
        // Test setup
        logger.info("TEST_START | Test: Complete Authentication Flow");
        
        // Test execution
        LoginRequest request = new LoginRequest();
        request.setEmail("test@example.com");
        request.setPassword("password123");
        
        LoginResponse response = authService.authenticate(request);
        
        // Verify logging occurred (can be done with log capture)
        assertThat(response).isNotNull();
        
        logger.info("TEST_END | Test: Complete Authentication Flow | Success: true");
    }
}
```

## Environment-Specific Best Practices

### 1. Development Environment

```java
// Development - verbose logging
if ("development".equals(environment)) {
    logger.debug("DEV_INFO | Request: {} | Headers: {} | Params: {}", 
        request, headers, params);
}
```

### 2. Production Environment

```java
// Production - minimal but essential logging
logger.info("API_REQUEST | Endpoint: {} | Method: {} | UserId: {} | Duration: {}ms", 
    endpoint, method, userId, duration);

// Avoid logging request/response bodies in production
if (!"production".equals(environment)) {
    logger.debug("Request body: {}", requestBody);
}
```

### 3. Security Logging in Production

```java
// Always log security events regardless of environment
logger.security("UNAUTHORIZED_ACCESS", correlationId, 
    "IP: {} | Endpoint: {} | User: {} | Timestamp: {}", 
    clientIP, endpoint, userId, LocalDateTime.now());

logger.audit("SENSITIVE_DATA_ACCESS", userId,
    "Resource: {} | Action: {} | Reason: {}", 
    resourceId, action, accessReason);
```

## Code Organization Best Practices

### 1. Centralized Logging Utilities

```java
@Component
public class LoggingUtils {
    
    public static String maskEmail(String email) {
        // Implementation
    }
    
    public static String maskPhone(String phone) {
        // Implementation
    }
    
    public static String generateCorrelationId() {
        return UUID.randomUUID().toString().substring(0, 8);
    }
    
    public static String formatDuration(long milliseconds) {
        return milliseconds + "ms";
    }
}
```

### 2. Service-Specific Loggers

```java
// Authentication Service
@Service
public class AuthenticationService {
    private final CommonLogger logger = CommonLogger.getLogger(AuthenticationService.class);
    
    // Service methods with consistent logging patterns
}

// User Service
@Service
public class UserService {
    private final CommonLogger logger = CommonLogger.getLogger(UserService.class);
    
    // Service methods with consistent logging patterns
}
```

### 3. Logging Constants

```java
public class LoggingConstants {
    // Operation prefixes
    public static final String AUTH_PREFIX = "AUTH_";
    public static final String USER_PREFIX = "USER_";
    public static final String ORDER_PREFIX = "ORDER_";
    
    // Common log formats
    public static final String OPERATION_START = "{}_START | CorrelationId: {} | User: {}";
    public static final String OPERATION_SUCCESS = "{}_SUCCESS | CorrelationId: {} | Duration: {}ms";
    public static final String OPERATION_FAILED = "{}_FAILED | CorrelationId: {} | Error: {}";
    
    // Security event types
    public static final String LOGIN_ATTEMPT = "LOGIN_ATTEMPT";
    public static final String LOGIN_SUCCESS = "LOGIN_SUCCESS";
    public static final String LOGIN_FAILURE = "LOGIN_FAILURE";
    public static final String UNAUTHORIZED_ACCESS = "UNAUTHORIZED_ACCESS";
}
```

This comprehensive best practices guide ensures consistent, secure, and effective logging across your entire application ecosystem.
