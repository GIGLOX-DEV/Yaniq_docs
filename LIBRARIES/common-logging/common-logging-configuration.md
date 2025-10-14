# CommonLogger Configuration Guide

## Environment Configuration

### Primary Configuration

The CommonLogger library uses environment variables for configuration to support containerized deployments and different environments.

#### LOG_MODE Configuration

```bash
# Set the logging strategy
export LOG_MODE=CONSOLE     # Default console output
export LOG_MODE=ELK         # ELK Stack compatible JSON
export LOG_MODE=FILE        # File-based with rotation
export LOG_MODE=STRUCTURED  # Pure JSON structured logs
```

#### Service Configuration

```bash
# Service identification for ELK logs
export service.name=auth-service

# Version information
export service.version=1.0.0

# Environment identification
export service.environment=production
```

#### File Logging Configuration

```bash
# Custom log directory (default: logs/)
export yaniq.log.dir=/var/logs/yaniq

# Enable debug level for file logging
export yaniq.log.debug=true

# Enable trace level for file logging
export yaniq.log.trace=true
```

## Docker Configuration

### Docker Compose Example

```yaml
version: '3.8'
services:
  auth-service:
    image: yaniq/auth-service:latest
    environment:
      - LOG_MODE=ELK
      - service.name=auth-service
      - service.version=1.2.0
      - service.environment=production
      - yaniq.log.debug=false
    volumes:
      - ./logs:/var/logs/yaniq
```

### Kubernetes ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: logging-config
data:
  LOG_MODE: "ELK"
  service.name: "auth-service"
  service.version: "1.2.0"
  service.environment: "production"
  yaniq.log.debug: "false"
  yaniq.log.trace: "false"
```

## Strategy-Specific Configuration

### ELK Strategy Configuration

The ELK strategy produces JSON logs optimized for Elasticsearch ingestion:

```bash
# ELK Configuration
export LOG_MODE=ELK
export service.name=auth-service
export service.version=1.0.0
export service.environment=production
```

**Sample ELK Output:**
```json
{
  "@timestamp": "2025-10-14T10:30:15.123",
  "@version": "1",
  "level": "INFO",
  "logger_name": "AuthenticationService",
  "message": "AUTH_SUCCESS | CorrelationId: abc123 | UserId: 456",
  "service_name": "auth-service",
  "service_version": "1.0.0",
  "service_environment": "production",
  "thread_name": "http-nio-8080-exec-1",
  "host": "auth-server-01",
  "tags": ["yaniq", "auth-service", "info"]
}
```

### File Strategy Configuration

```bash
# File logging configuration
export LOG_MODE=FILE
export yaniq.log.dir=/var/logs/yaniq
export yaniq.log.debug=true
export yaniq.log.trace=false
```

**File Organization:**
```
/var/logs/yaniq/
├── AuthenticationService-2025-10-14.log
├── ValidationService-2025-10-14.log
├── UserService-2025-10-14.log
└── DefaultLogger-2025-10-14.log
```

### Structured Strategy Configuration

For custom log processing systems:

```bash
export LOG_MODE=STRUCTURED
```

**Sample Structured Output:**
```json
{
  "timestamp": "2025-10-14T10:30:15.123",
  "level": "INFO",
  "logger": "AuthenticationService",
  "message": "User authentication successful",
  "thread": "http-nio-8080-exec-1"
}
```

## Application Properties Integration

### Spring Boot Integration

```yaml
# application.yml
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

### Configuration Bean

```java
@Configuration
@ConfigurationProperties(prefix = "yaniq.logging")
@Data
public class LoggingConfiguration {
    private String mode = "CONSOLE";
    private boolean debug = false;
    private boolean trace = false;
    private String directory = "logs";
    
    @PostConstruct
    public void configureLogging() {
        System.setProperty("LOG_MODE", mode);
        System.setProperty("yaniq.log.debug", String.valueOf(debug));
        System.setProperty("yaniq.log.trace", String.valueOf(trace));
        System.setProperty("yaniq.log.dir", directory);
    }
}
```

## Environment-Specific Configuration

### Development Environment

```bash
export LOG_MODE=CONSOLE
export yaniq.log.debug=true
export yaniq.log.trace=true
export service.environment=development
```

### Testing Environment

```bash
export LOG_MODE=STRUCTURED
export yaniq.log.debug=true
export yaniq.log.trace=false
export service.environment=testing
```

### Production Environment

```bash
export LOG_MODE=ELK
export yaniq.log.debug=false
export yaniq.log.trace=false
export service.environment=production
export service.name=auth-service
export service.version=1.2.0
```

## Performance Tuning

### Async Executor Configuration

The CommonLogger uses an internal thread pool for asynchronous logging. While this is handled automatically, you can monitor performance:

```java
// Monitor logger performance
logger.metric("logger_queue_size", LogExecutor.getQueueSize());
logger.performance("log_processing", processingTime, "Strategy: {}", strategyName);
```

### Memory Optimization

For high-throughput applications:

```bash
# Disable trace and debug in production
export yaniq.log.debug=false
export yaniq.log.trace=false

# Use structured logging for better performance
export LOG_MODE=STRUCTURED
```

## Security Configuration

### Sensitive Data Masking

Configure automatic masking of sensitive data:

```java
@Configuration
public class LoggingSecurityConfig {
    
    @Bean
    public DataMasker dataMasker() {
        return DataMasker.builder()
            .maskEmail(true)
            .maskPhone(true)
            .maskCreditCard(true)
            .maskSSN(true)
            .build();
    }
}
```

### Audit Configuration

For compliance requirements:

```bash
# Enable audit logging
export yaniq.audit.enabled=true
export yaniq.audit.level=INFO
export yaniq.audit.retention.days=2555  # 7 years
```

## Monitoring and Observability

### Integration with Monitoring Systems

#### Prometheus Integration

```java
@Component
public class LoggingMetrics {
    private final Counter logCounter = Counter.build()
        .name("yaniq_log_messages_total")
        .help("Total log messages")
        .labelNames("level", "service")
        .register();
    
    @EventListener
    public void onLogEvent(LogEvent event) {
        logCounter.labels(event.getLevel(), event.getService()).inc();
    }
}
```

#### ELK Stack Integration

```yaml
# Logstash configuration
input {
  beats {
    port => 5044
  }
}

filter {
  if [fields][service] == "yaniq" {
    json {
      source => "message"
    }
    
    date {
      match => [ "@timestamp", "ISO8601" ]
    }
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "yaniq-logs-%{+YYYY.MM.dd}"
  }
}
```

## Troubleshooting Configuration

### Common Configuration Issues

1. **Logs not appearing in expected format**
   ```bash
   # Check current configuration
   echo $LOG_MODE
   echo $service.name
   
   # Verify strategy is loaded
   grep "LogStrategy" application.log
   ```

2. **File logging permission issues**
   ```bash
   # Check directory permissions
   ls -la /var/logs/yaniq
   
   # Fix permissions
   sudo chown -R appuser:appgroup /var/logs/yaniq
   sudo chmod 755 /var/logs/yaniq
   ```

3. **ELK logs not parsing correctly**
   ```bash
   # Test JSON format
   echo '{"@timestamp":"2025-10-14T10:30:15.123","level":"INFO"}' | jq .
   
   # Check Logstash configuration
   curl -XGET 'localhost:9200/_cat/indices?v'
   ```

### Debug Configuration

Enable debug mode for the logging library itself:

```bash
# Enable logging library debug
export yaniq.logging.internal.debug=true

# Increase verbosity
export yaniq.logging.internal.trace=true
```

This will output internal logging library operations to help diagnose configuration issues.

---

**Next Steps:**
- Review the [Usage Guide](common-logging-usage.md) for implementation examples
- Check the [API Reference](common-logging-api.md) for detailed method documentation
- See [Best Practices](common-logging-best-practices.md) for recommended patterns
