# CommonLogger API Reference

## Core Classes

### CommonLogger

The main logging interface providing structured logging capabilities with placeholder support.

#### Factory Methods

```java
// Get default logger instance
public static CommonLogger getLogger()

// Get logger for specific class
public static CommonLogger getLogger(Class<?> clazz)

// Get named logger
public static CommonLogger getLogger(String name)
```

#### Basic Logging Methods

##### INFO Level
```java
public void info(String message)
public void info(String format, Object... args)
public void info(String message, Throwable throwable)
```

**Examples:**
```java
logger.info("User authenticated successfully");
logger.info("User {} authenticated in {}ms", userId, duration);
logger.info("Authentication completed", exception);
```

##### WARN Level
```java
public void warn(String message)
public void warn(String format, Object... args)
public void warn(String message, Throwable throwable)
```

##### ERROR Level
```java
public void error(String message)
public void error(String format, Object... args)
public void error(String message, Throwable throwable)
public void error(String format, Throwable throwable, Object... args)
```

##### DEBUG Level
```java
public void debug(String message)
public void debug(String format, Object... args)
public void debug(String message, Throwable throwable)
```

##### TRACE Level
```java
public void trace(String message)
public void trace(String format, Object... args)
public void trace(String message, Throwable throwable)
```

##### FATAL Level
```java
public void fatal(String message)
public void fatal(String format, Object... args)
public void fatal(String message, Throwable throwable)
```

#### Specialized Logging Methods

##### Security Logging
```java
public void security(String eventType, String correlationId, String format, Object... args)
```

**Parameters:**
- `eventType`: Type of security event (LOGIN_ATTEMPT, UNAUTHORIZED_ACCESS, etc.)
- `correlationId`: Unique identifier for request tracking
- `format`: Message format with {} placeholders
- `args`: Arguments to substitute in format

**Example:**
```java
logger.security("LOGIN_FAILURE", "abc123", "User: {} | IP: {} | Reason: {}", 
    maskedEmail, clientIP, "Invalid credentials");
```

##### Audit Logging
```java
public void audit(String eventType, String userId, String format, Object... args)
```

**Parameters:**
- `eventType`: Type of audit event
- `userId`: ID of the user performing the action
- `format`: Message format with {} placeholders
- `args`: Arguments to substitute

**Example:**
```java
logger.audit("USER_DELETE", adminId, "Deleted user: {} | Reason: {}", 
    targetUserId, "Account violation");
```

##### Performance Logging
```java
public void performance(String operation, long duration, String format, Object... args)
```

**Parameters:**
- `operation`: Name of the operation being measured
- `duration`: Duration in milliseconds
- `format`: Additional message format
- `args`: Arguments to substitute

**Example:**
```java
logger.performance("database_query", 150, "Table: {} | Records: {}", 
    tableName, recordCount);
```

##### Metrics Logging
```java
public void metric(String metricName, Object value, String... tags)
```

**Parameters:**
- `metricName`: Name of the metric
- `value`: Metric value
- `tags`: Additional tags for the metric

**Example:**
```java
logger.metric("active_users", userCount, "service:auth", "region:us-east");
```

#### Level Checking Methods

```java
public boolean isInfoEnabled()
public boolean isWarnEnabled()
public boolean isErrorEnabled()
public boolean isDebugEnabled()
public boolean isTraceEnabled()
```

**Usage:**
```java
if (logger.isDebugEnabled()) {
    String expensiveData = generateDebugInfo();
    logger.debug("Debug data: {}", expensiveData);
}
```

#### Utility Methods

##### Structured Logging Helper
```java
public String structured(Object... keyValuePairs)
```

Creates structured key-value log entries. Requires even number of arguments.

**Example:**
```java
String structuredData = logger.structured(
    "userId", 123,
    "operation", "login",
    "duration", 150,
    "success", true
);
logger.info("Operation completed: {}", structuredData);
// Output: Operation completed: userId: 123 | operation: login | duration: 150 | success: true
```

##### Flush Method
```java
public void flush()
```

Forces processing of pending asynchronous log messages. Useful for testing or shutdown.

## Logging Strategies

### LogStrategy Interface

Base interface for all logging implementations.

```java
public interface LogStrategy {
    // Basic logging methods
    void info(String message);
    void info(String message, Throwable throwable);
    void warn(String message);
    void warn(String message, Throwable throwable);
    void error(String message);
    void error(String message, Throwable throwable);
    void debug(String message);
    void debug(String message, Throwable throwable);
    void trace(String message);
    void trace(String message, Throwable throwable);
    void fatal(String message);
    void fatal(String message, Throwable throwable);
    
    // Level checking
    boolean isInfoEnabled();
    boolean isWarnEnabled();
    boolean isErrorEnabled();
    boolean isDebugEnabled();
    boolean isTraceEnabled();
}
```

### Available Strategies

#### ConsoleLogStrategy
- **Purpose**: Standard console output using SLF4J
- **Constructor**: `ConsoleLogStrategy()` or `ConsoleLogStrategy(String loggerName)`
- **Output Format**: Standard SLF4J format

#### ELKLogStrategy
- **Purpose**: ELK Stack compatible JSON logs
- **Constructor**: `ELKLogStrategy()` or `ELKLogStrategy(String loggerName)`  
- **Output Format**: JSON with ELK standard fields
- **Special Fields**: 
  - `@timestamp`: ISO datetime
  - `@version`: Log format version
  - `service_name`: Service identifier
  - `tags`: Array of filterable tags

#### FileLogStrategy
- **Purpose**: File-based logging with daily rotation
- **Constructor**: `FileLogStrategy()` or `FileLogStrategy(String loggerName)`
- **Output Format**: Structured text format
- **File Pattern**: `{logger-name}-{YYYY-MM-DD}.log`
- **Directory**: Configurable via `yaniq.log.dir` property

#### StructuredLogStrategy
- **Purpose**: Pure JSON structured logs
- **Constructor**: `StructuredLogStrategy()` or `StructuredLogStrategy(String loggerName)`
- **Output Format**: Clean JSON structure
- **Use Case**: Custom log processing systems

## Configuration Classes

### LoggerContext

Manages CommonLogger instances with caching and lifecycle management.

```java
public class LoggerContext {
    public static LoggerContext getInstance()
    public CommonLogger getLogger()
    public CommonLogger getLogger(Class<?> clazz)
    public CommonLogger getLogger(String name)
    public void clearCache()
    public int getCacheSize()
}
```

### LogStrategyFactory

Creates appropriate LogStrategy instances based on configuration.

```java
public class LogStrategyFactory {
    public static LogStrategy getLogStrategy()
    public static LogStrategy getLogStrategy(String loggerName)
    public static String[] getAvailableModes()
    public static String getCurrentMode()
}
```

### LogExecutor

Manages asynchronous execution of logging operations.

```java
public class LogExecutor {
    public static ExecutorService getExecutorService()
    public static void shutdown()
}
```

## Configuration Properties

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `LOG_MODE` | `CONSOLE` | Logging strategy selection |
| `service.name` | `yaniq-service` | Service name for ELK logs |
| `service.version` | `1.0.0` | Service version |
| `service.environment` | `development` | Environment identifier |
| `yaniq.log.dir` | `logs` | Log directory for file strategy |
| `yaniq.log.debug` | `false` | Enable debug level |
| `yaniq.log.trace` | `false` | Enable trace level |

### Valid LOG_MODE Values

- `CONSOLE`: Standard console output (default)
- `ELK`: ELK Stack compatible JSON
- `FILE`: File-based with daily rotation  
- `STRUCTURED`: Pure JSON structured logs

## Error Handling

### Common Exceptions

The CommonLogger library handles exceptions gracefully:

1. **JSON Serialization Errors**: Falls back to simple string format
2. **File I/O Errors**: Logs to System.err and continues
3. **Network Errors**: Buffers locally where possible
4. **Thread Pool Exhaustion**: Uses caller thread as fallback

### Exception Logging Best Practices

```java
try {
    riskyOperation();
} catch (SpecificException e) {
    logger.error("Operation failed | Type: {} | Code: {} | Details: {}", 
        e.getClass().getSimpleName(), e.getErrorCode(), e.getMessage(), e);
} catch (Exception e) {
    logger.fatal("Unexpected error | Operation: {} | Type: {}", 
        operationName, e.getClass().getSimpleName(), e);
}
```

## Performance Characteristics

### Asynchronous Processing
- All logging operations are asynchronous by default
- Uses single-threaded executor for message ordering
- Minimal impact on application threads

### Memory Usage
- Efficient placeholder replacement
- Minimal object creation for structured logging
- Automatic cleanup of thread-local data

### Throughput
- Optimized for high-throughput applications
- Batch processing where applicable
- Configurable buffer sizes

## Thread Safety

The CommonLogger library is fully thread-safe:

- **Immutable Configuration**: Strategy selection is immutable after initialization
- **Thread-Safe Caching**: Logger instances are cached safely
- **Concurrent Access**: Multiple threads can safely use the same logger instance
- **Async Processing**: Thread pool handles concurrent log messages safely

## Integration Examples

### Spring Boot Integration

```java
@Configuration
public class LoggingConfig {
    
    @Bean
    @Primary
    public CommonLogger commonLogger() {
        return CommonLogger.getLogger("application");
    }
    
    @Bean
    public CommonLogger authLogger() {
        return CommonLogger.getLogger("auth-service");
    }
}

@Service
public class MyService {
    private final CommonLogger logger;
    
    public MyService(CommonLogger logger) {
        this.logger = logger;
    }
}
```

### Aspect-Oriented Logging

```java
@Aspect
@Component
public class LoggingAspect {
    private final CommonLogger logger = CommonLogger.getLogger();
    
    @Around("@annotation(Loggable)")
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        long startTime = System.currentTimeMillis();
        String methodName = joinPoint.getSignature().getName();
        
        try {
            Object result = joinPoint.proceed();
            long duration = System.currentTimeMillis() - startTime;
            
            logger.performance(methodName, duration, "Args: {}", joinPoint.getArgs());
            return result;
            
        } catch (Exception e) {
            long duration = System.currentTimeMillis() - startTime;
            logger.error("Method {} failed after {}ms", methodName, duration, e);
            throw e;
        }
    }
}
```

---

## Version Information

**Library Version**: 2.0  
**API Compatibility**: Backward compatible with 1.x  
**Java Requirements**: Java 11+  
**Dependencies**: SLF4J, Jackson (for JSON strategies)

For implementation examples and advanced usage patterns, see the [Usage Guide](common-logging-usage.md) and [Best Practices](common-logging-best-practices.md).
